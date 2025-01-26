extends Node
class_name WorldManager

var placedBlocks: Array[Block]

#block grid
@export var gridSize: int
@export var blockSize: int
var grid: Array[GridNode]
var directionMappingX: Array[int] = [0,1,0,-1]
var directionMappingY: Array[int] = [-1,0,1,0]

#placing blocks
var placingBlock: bool
var blockBeingPlaced: Block
var selectedConfiguration
var configurationHead: int

#moving blocks
var movingBlocks: bool
var blockLifted: Block

#wiring
@onready var wireScene: PackedScene = preload("res://MiscScenes/wire.tscn")
var wiring:bool
var wiringStart: Array[int] = [0,0]
var wiringEnd: Array[int] = [0,0]
var layingWire: bool
var wireSprites : Array[Texture2D] = [
	
	preload("res://Sprites/Wiring/disconnected.png"),#0
	preload("res://Sprites/Wiring/end_left.png"),#1
	preload("res://Sprites/Wiring/end_down.png"),#2
	preload("res://Sprites/Wiring/l_down.png"),#3
	preload("res://Sprites/Wiring/end_right.png"),#4
	preload("res://Sprites/Wiring/line_h.png"),#5
	preload("res://Sprites/Wiring/l_right.png"),#6
	preload("res://Sprites/Wiring/t_down.png"),#7
	preload("res://Sprites/Wiring/end_up.png"),#8
	preload("res://Sprites/Wiring/l_left.png"),#9
	preload("res://Sprites/Wiring/line_v.png"),#10
	preload("res://Sprites/Wiring/t_left.png"),#11
	preload("res://Sprites/Wiring/l_up.png"),#12
	preload("res://Sprites/Wiring/t_up.png"),#13
	preload("res://Sprites/Wiring/t_right.png"),#14
	preload("res://Sprites/Wiring/x.png"),#15
	
]

#saving
var sessionWorldChanges: Array[SessionWorldChange]
var worldChanges:Array[SessionWorldChange]

#other
@onready var miningDebug: PackedScene = preload("res://MiscScenes/mining_debug.tscn")
@onready var hudMessage: Label = %HUDMessage
var debugSerializationHead:int

#explosions
@onready var explosionPackedScene: PackedScene = preload("res://MiscScenes/explosion.tscn")
var explosionPool: Array[Explosion]

func _enter_tree():
	Global.worldManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeGrid()
	ScaleUpExplosionPool()
	#Global.saveManager.Subscribe(self)
	pass # Replace with function body.

func LoadDevMode(seed):
	await get_tree().create_timer(0.1).timeout
	SetMiningValues(seed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if layingWire:
		UpdateLaidWire()
	
	if placingBlock:
		
		var array = WorldToGrid(Global.mouseManager.GetMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			StopPlacingBlock()
	
		if Input.is_action_just_pressed("mouse1"):
			
			PlayerPlaceBlock()
			
		if blockBeingPlaced.configurations.size() > 0: # has many configurations
			
			if Input.is_action_just_pressed("reload"):
				configurationHead = configurationHead + 1
				if configurationHead > blockBeingPlaced.configurations.size()-1:
					configurationHead = -1
				UpdateConfiguration()
			elif Input.is_action_just_pressed("mouse_wheel_up"):
				configurationHead = configurationHead - 1
				if configurationHead < -1:
					configurationHead = blockBeingPlaced.configurations.size()-1
				UpdateConfiguration()
			elif Input.is_action_just_pressed("mouse_wheel_down"):
				configurationHead = configurationHead + 1
				if configurationHead > blockBeingPlaced.configurations.size()-1:
					configurationHead = -1
				UpdateConfiguration()
				
			
	if movingBlocks: #DISASSEMBLING
		
		var array = WorldToGrid(Global.mouseManager.GetMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			StopMovingBlocks()
			
		if Input.is_action_just_pressed("mouse1"):
			
			var node: GridNode = GetNodeAt(array[0], array[1])
			
			if node == null:
				return
			
			if node.wire != null:
				PlayerRemoveWiring(node.wire)
				return
			
			if node.block == null || node.block.immovable:
				return
			blockLifted = node.block
			
			Global.inventoryMenu.GetResourcesFromDisassembledBlock(blockLifted)
			var wiring: Array[bool]
			NewSessionWorldChange(blockLifted.xGridPos, blockLifted.yGridPos,null,wiring)
			blockLifted.Destroy()
			
			blockLifted = null
			#StopMovingBlocks()
				
	if wiring:
		var array = WorldToGrid(Global.mouseManager.GetMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			StopWiring()
		
		if Input.is_action_just_pressed("mouse1"):
			layingWire = true
			wiringStart = array
			
		if Input.is_action_just_released("mouse1"):
			if !layingWire:
				return
			layingWire = false
			PlayerPlaceWiring()
			
	if !movingBlocks && !placingBlock && !wiring:
		
		if Input.is_action_just_pressed("mouse2"):
			var array = WorldToGrid(Global.mouseManager.GetMousePosition())
			var node: GridNode = GetNodeAt(array[0], array[1])
			if node != null && node.block != null:
				node.block.PlayerInteract()
		
	pass

#placing blocks
func StartPlacingBlock(block: Block):
	if placingBlock == true:
		return
	
	placingBlock = true
	blockBeingPlaced = block
	configurationHead = -1
	Global.gameManager.CloseAllWindows()
	Global.hud.visible = false
	Global.gridSelect.texture = blockBeingPlaced.menuIcon
	Global.cursor.visible = false
	hudMessage.text = "Left click to place a block. Scroll/R to rotate block. Right click to escape."
	Global.gridSelect.modulate = Color.AQUA
	Global.gridSelect.modulate.a = 0.75
	Global.gridSelect.visible = true
	pass
	
func StopPlacingBlock():
	placingBlock = false
	Global.hud.visible = true
	hudMessage.text = ""
	Global.gridSelect.visible = false
	Global.cursor.visible = true

func StartMovingBlocks():
	if movingBlocks == true:
		return
	movingBlocks = true
	Global.gameManager.CloseAllWindows()
	Global.hud.visible = false
	Global.gridSelect.modulate = Color.WHITE
	#Global.gridSelect.label.text = "Click"
	hudMessage.text = "Left click to dissemble block. Right click to escape."
	Global.gridSelect.texture = Global.gridSelect.sprites[3]
	Global.gridSelect.visible = true
	Global.cursor.visible = false

func StopMovingBlocks(): #START DISASSEMBLING
	movingBlocks = false
	#Global.gridSelect.texture = Global.gridSelect.sprites[3]
	Global.hud.visible = true
	hudMessage.text = ""
	Global.gridSelect.visible = false
	Global.cursor.visible = true
	
func PlayerPlaceBlock():
	
	var finalBlock:Block = blockBeingPlaced
	if configurationHead > -1:
		finalBlock = Global.buildMenu.GetBlockReferenceByName(blockBeingPlaced.configurations[configurationHead])
	
	var mousePosition: Vector2 = Global.mouseManager.GetMousePosition()
	
	var gridPosition = WorldToGrid(mousePosition)
	var node = GetNodeAt(gridPosition[0], gridPosition[1])
	if node == null || node.block != null: #position already occupied
		Global.effectManager.DisplayText(Global.player.global_position, "Can't do that!")
		print("Already occupied or outside of the map")
		return
	
	if finalBlock.components.size()!= 0:
		var i:int = 0 
		var array: Array[ResourceTuple]
		for component in finalBlock.components:
			var tuple = Global.resourceManager.NewResourceTuple(component,finalBlock.componentAmounts[i],false)
			array.push_back(tuple)
			i = i + 1
			
		if !Global.inventoryMenu.RequireResources(array, true) && !Global.gameManager.devMode:
			Global.effectManager.DisplayText(Global.player.global_position,"I'm missing resources!")
			return
	
	var block:Block = finalBlock.duplicate()
	PlaceBlock(block,gridPosition[0],gridPosition[1])
	
	if block.debugNumber != null:
		block.debugNumber.text = str(debugSerializationHead)
		block.name = str("block_", debugSerializationHead)
		debugSerializationHead = debugSerializationHead + 1
	
	var wiring: Array[bool]
	if node.wire != null:
		wiring = node.wire.GetConnectionStatus()
	
	NewSessionWorldChange(gridPosition[0], gridPosition[1], block,wiring)
	
func UpdateConfiguration():
	if configurationHead == -1: #select the base block
		Global.gridSelect.texture = blockBeingPlaced.menuIcon
		return
	
	Global.gridSelect.texture = Global.buildMenu.GetBlockReferenceByName(blockBeingPlaced.configurations[configurationHead]).menuIcon
	
	pass
	
func PlaceBlock(block:Block, x:int, y:int):
	
	SetBlockAt(block, x, y)
	block.xGridPos = x
	block.yGridPos = y
	
	var worldPosition = GridToWorld(x, y)
	add_child(block)
	block.name = block.blockName
	block.global_position = worldPosition
	block.placed = true
	placedBlocks.push_back(block)
	block.OnPlace()
	
	pass

func ForcePlaceBlock(block:Block, x:int, y:int):
	var node = GetNodeAt(x, y)
	if node.block != null: #position already occupied
		node.block.Destroy()
		return
	
	PlaceBlock(block, x, y)
	
	pass

func RemoveBlock(x:int, y:int):
	var node = GetNodeAt(x,y)
	placedBlocks.erase(node.block)
	node.block = null

#block grid
func InitializeGrid():
	var size = gridSize * gridSize
	grid.resize(size)
	
	for y in gridSize:
		for x in gridSize:
			var i = x + y*gridSize
			grid[i] = GridNode.new()
			grid[i].x = x
			grid[i].y = y
	
	pass

func SetBlockAt(block:Block, x: int, y: int):
	var i = x + y*gridSize
	
	var _block = grid[i].block #check if theres a block and delete it
	if _block != null:
		print_rich("[color=red]Tried to SetBlockAt() on already occupied position![/color]")
	
	grid[i].block = block
	
	pass

func GetNodeAt(x:int, y:int)->GridNode:
	
	if x < 0 || x > gridSize - 1:
		return null
	if y < 0 || y > gridSize - 1:
		return null
	
	var i = x + y*gridSize
	var node = grid[i]
	return node
	pass

func WorldToGrid(worldPosition: Vector2)->Array[int]:
	var x:int = round(worldPosition.x / blockSize)
	var y:int = round(worldPosition.y / blockSize)
	var array: Array[int] = [x,y]
	return array
	pass

func GridToWorld(x:int,y:int)-> Vector2:
	var _x: float = x * blockSize
	var _y: float = y * blockSize
	return Vector2(_x,_y)
	pass

func GetNeighbors(x:int, y:int)-> Array[GridNode]:
	
	
	var array: Array[GridNode]
	array.resize(4)
	
	array[0] = GetNodeAt(x,y-1)
	array[1] = GetNodeAt(x+1,y)
	array[2] = GetNodeAt(x,y+1)
	array[3] = GetNodeAt(x-1,y)
	
	return array 

func GetEmpty(x:int, y:int)->GridNode:
	
	var _x = randi_range(-1,1)
	var _y = randi_range(-1,1)
	
	if _x+_y == 0:
		_x = 1
	
	for i in 100:
		var node = GetNodeAt(x+_x*i,y+_y*i)
		if node == null:
			return null
		if node.block == null:
			return node
	
	return null
	
	pass

#Wiring
func StartWiring():
	if wiring:
		return
	wiring = true
	Global.gameManager.CloseAllWindows()
	Global.hud.visible = false
	Global.gridSelect.texture = Global.gridSelect.sprites[0]
	Global.gridSelect.modulate = Color.WHITE
	hudMessage.text = "Drag left click to lay wire. Right click to escape."
	Global.cursor.visible = false
	Global.gridSelect.visible = true

func StopWiring():
	if !wiring:
		return
	wiring = false
	Global.hud.visible = true
	hudMessage.text = ""
	Global.gridSelect.visible = false
	Global.cursor.visible = true
	
func PlayerPlaceWiring():
	
	var a = Vector2(wiringStart[0], wiringStart[1])
	var b = Vector2(wiringEnd[0], wiringEnd[1])
	var length : int = (b-a).length()
	var tuple = ResourceTuple.new()
	tuple.resource_name = "Wire"
	tuple.amount = length
	var array: Array[ResourceTuple] = [tuple]
	if !Global.inventoryMenu.RequireResources(array, true) && !Global.gameManager.devMode:
		Global.effectManager.DisplayText(Global.player.global_position,"I'm missing wire!")
		return
		
	PlaceWiringFromTo(wiringStart, wiringEnd)
	
	pass

func UpdateLaidWire():
	
		var cursor: Array[int] = WorldToGrid(Global.mouseManager.GetMousePosition())
		if abs(cursor[0] - wiringStart[0]) > abs(cursor[1] - wiringStart[1]): #is more in x
			wiringEnd[0] = cursor[0]
			wiringEnd[1] = wiringStart[1]
		else:# is more in y
			wiringEnd[0] = wiringStart[0]
			wiringEnd[1] = cursor[1]
		
		#TODO: update indicator	

func PlaceWiringFromTo(start: Array[int], end: Array[int]):
	if start == end:
		return
	
	var step: Array[int] = [0,0]
	step[0] = clamp(end[0]-start[0],-1,1)
	step[1] = clamp(end[1]-start[1],-1,1)
	#print(step[0], ",",step[1])
	
	var position: Array[int] = start
	var lastOne: bool = false
	var lastWire: Wire
	var wiresEdited: Array[Wire]
	while(true):
		
		if position[0] == end[0] && position[1] == end[1]:
			lastOne = true
		
		var node:GridNode = GetNodeAt(position[0], position[1])
		
		if node.wire == null: #doesnt yet have wire
			var instance:Wire = wireScene.instantiate()
			add_child(instance)
			instance.global_position = GridToWorld(position[0],position[1])
			node.wire = instance
			node.wire.connections = [null,null,null,null]
			if node.block != null && node.block is ConductionBlock && node.block.isWireTerminal:
				node.wire.connectedBlock = node.block
				node.block.connectedWire = node.wire
			node.wire.x = node.x
			node.wire.y = node.y
		
		wiresEdited.push_back(node.wire)
		
		if lastWire != null: #connect to last step wire
			if !lastWire.connections.has(node.wire):
				lastWire.Connect(node.wire)
			if !node.wire.connections.has(lastWire):
				node.wire.Connect(lastWire)
			
		if lastOne: #connect the last wire being placed to the wire before that
			break
		
		lastWire = node.wire
		position[0] = position[0] + step[0]
		position[1] = position[1] + step[1]
		
	for wire in wiresEdited:
		wire.UpdateVisuals()
		var node: GridNode = GetNodeAt(wire.x,wire.y)
		NewSessionWorldChange(wire.x, wire.y, node.block, node.wire.GetConnectionStatus())
		
	
	pass	

func ForcePlaceWiring(xPos: int, yPos:int, connections :Array[bool]):
	var node:GridNode = GetNodeAt(xPos, yPos)
	var instance:Wire = wireScene.instantiate()
	add_child(instance)
	instance.global_position = GridToWorld(xPos,yPos)
	node.wire = instance
	node.wire.connections = [null,null,null,null]
	node.wire.x = xPos
	node.wire.y = yPos
	
	if node.block != null && node.block is ConductionBlock && node.block.isWireTerminal:
		node.wire.connectedBlock = node.block
		node.block.connectedWire = node.wire
	
	var i :int
	for connection in connections:
		if connection == true:
			var neighbor:GridNode = GetNodeAt(xPos+directionMappingX[i], yPos+directionMappingY[i])
			if neighbor.wire != null:
				node.wire.connections[i] = neighbor.wire
				neighbor.wire.Connect(node.wire)
				neighbor.wire.UpdateVisuals()
		i=i+1
	
	node.wire.UpdateVisuals()
	
	pass

func PlayerRemoveWiring(wire:Wire):
	var x:int = wire.x
	var y:int = wire.y
	
	if wire.connectedBlock != null:
		wire.connectedBlock.connectedWire == null
		
	var neighbors:Array[GridNode] = GetNeighbors(x,y)
	for neighbor in neighbors:
		if neighbor.wire != null:
			neighbor.wire.Disconnect(wire)
			neighbor.wire.UpdateVisuals()
			
			NewSessionWorldChange(neighbor.x, neighbor.y, neighbor.block, neighbor.wire.GetConnectionStatus())
			
	var node: GridNode = GetNodeAt(x,y)
	var wiring: Array[bool]
	NewSessionWorldChange(x, y, node.block, wiring)
	
	wire.queue_free()


#World generation
func SetMiningValues(seed: String):
	var miningNoise: FastNoiseLite = FastNoiseLite.new()
	miningNoise.seed = hash(seed)
	for y in gridSize:
		for x in gridSize:
			var i = x + y*gridSize
			var value1:float = miningNoise.get_noise_2d(x*4, y*5) / 2
			var value2:float = miningNoise.get_noise_2d((x+1000)*5, (y+1000)*5) / 2
			var value:float = value1 + value2
			
			var _debug = false
			if _debug:
				var debug:Node2D = miningDebug.instantiate()
				add_child(debug)
				debug.global_position = GridToWorld(x,y)
				if value < -0.30:
					debug.modulate = Color.BLACK
				elif value < -0.20:
					debug.modulate = Color.GREEN
				elif value < -0.10:
					debug.modulate = Color.TAN
				elif value < 0.0:
					debug.modulate = Color.PURPLE
				elif value < 0.10:
					debug.modulate = Color.SKY_BLUE
				elif value < 0.20:
					debug.modulate = Color.RED
				elif value < 0.30:
					debug.modulate = Color.ORANGE
				else:
					debug.modulate = Color.BLUE
				
			grid[i].miningValue = value
	
	
	pass
	
func GenerateNaturalBlocks(seed:String):	
	#print("adgfdasg")
	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = hash(seed)
	
	for y in gridSize:
		for x in gridSize:
			
			if x == 0 || y == 0 || x == gridSize-1 || y == gridSize-1:
				var block = Global.buildMenu.GetBlockReferenceByName("Bedrock Block").duplicate()
				PlaceBlock(block, x, y)
				continue
			
			var value1:float = noise.get_noise_2d(x*4, y*5) / 2
			var value2:float = noise.get_noise_2d((x-1000)*5, (y-1000)*5) / 2
			var value:float = value1 + value2
			
			if value > 0: #generate rock
				var block = Global.buildMenu.GetBlockReferenceByName("Rock Block").duplicate()
				PlaceBlock(block, x, y)
			
			#await get_tree().create_timer(0.0).timeout
	
	pass
	
func ApplyChanges(saveData):
	
	for node in grid:
		node.savingFlag = false
		pass
		
	for change in saveData.worldChanges:
		var node = GetNodeAt(change.x,change.y)
		if !node.savingFlag:
			node.savingFlag = true
			
			if change.blockStatus != "":
				var block = Global.buildMenu.GetBlockReferenceByName(change.blockStatus).duplicate()
				if block != null:
					ForcePlaceBlock(block,change.x,change.y)
			
			if change.wiring.size() != 0:
				ForcePlaceWiring(change.x,change.y,change.wiring)
			
		else:
			change.outOfDate = true 
	pass
	
#Saving
func NewSessionWorldChange(x:int, y:int, blockStatus: Block, wiring:Array[bool]):
	var _blockStatus: String
	if blockStatus == null:
		_blockStatus = ""
	else:
		_blockStatus = blockStatus.blockName
	
	var new = SessionWorldChange.new()
	new.x = x
	new.y = y
	new.blockStatus = _blockStatus
	new.wiring = wiring
	print(wiring)
	sessionWorldChanges.push_front(new)
	pass
	
func Save():
	
	var saveData = Global.saveManager.loadedWorldData
	
	for node in grid:
		node.savingFlag = false
		pass
	
	for change in sessionWorldChanges:
		var node = GetNodeAt(change.x, change.y)
		if !node.savingFlag:
			node.savingFlag = true
			saveData.worldChanges.push_front(change)
	
	
	pass
	
func Load():
	
	var saveData = Global.saveManager.loadedWorldData
	#print("World manager loading...")
	#Apply seed
	Global.gameManager.SetLoadingScreenText("Setting mining values...")
	await get_tree().create_timer(0.1).timeout
	SetMiningValues(saveData.seed)
	
	Global.gameManager.SetLoadingScreenText("Generating world from seed...")
	await get_tree().create_timer(0.1).timeout
	GenerateNaturalBlocks(saveData.seed)
	
	#Apply changes
	Global.gameManager.SetLoadingScreenText("Applying world changes...")
	await get_tree().create_timer(0.1).timeout
	ApplyChanges(saveData)
	pass

#Explosion
func CreateExplosion(x:int, y:int, damagingPower:int, destroyingPower:int):
	var openNodes: Array[GridNode]
	var closedNodes: Array[GridNode]
	openNodes.push_back(GetNodeAt(x,y))
	
	while openNodes.size() > 0:
		print("bruh")
		var node: GridNode = openNodes.pop_front()
		var neighbors:Array[GridNode] = GetNeighbors(node.x, node.y)
		closedNodes.push_back(node)	
		
		for neighbor in neighbors:
			if openNodes.has(neighbor):
				continue
			if closedNodes.has(neighbor):
				continue
			if neighbor.block != null && neighbor.block.isSolid && destroyingPower <= 0:
				continue
			openNodes.push_back(neighbor)
			damagingPower = damagingPower - 1
			destroyingPower = destroyingPower - 1
		
		if damagingPower < 0:
			for _node in openNodes:
				closedNodes.push_back(_node)
			break
			
	for node in closedNodes:
		if node.block != null:
			node.block.Destroy()
		PlaceExplosionObject(node.x, node.y)
		
	pass
	
func PlaceExplosionObject(x:int, y:int):
	var instance:Explosion = PopFromExplosionPool()
	instance.global_position = GridToWorld(x,y)
	instance.visible = true
	instance.tick = 30
	instance.play("default")
	pass

func PopFromExplosionPool()-> Explosion:
	if explosionPool.size() <= 0:
		ScaleUpExplosionPool()
		return PopFromExplosionPool()
	
	return explosionPool.pop_front()
	

func ScaleUpExplosionPool():
	for i in 100:
		var instance: Explosion = explosionPackedScene.instantiate()
		add_child(instance)
		instance.visible = false
		instance.global_position = Vector2(-1000, 1000)
		explosionPool.push_back(instance)
		pass
		
func ReturnToExplosionPool(instance: Explosion):
	instance.visible = false
	instance.global_position = Vector2(-1000, 1000)
	explosionPool.push_back(instance)
	pass
