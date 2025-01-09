extends Node
class_name WorldManager

var placedBlocks: Array[Block]

#block grid
@export var gridSize: int
@export var blockSize: int
var grid: Array[GridNode]

#placing blocks
var placingBlock: bool
var blockBeingPlaced: Block
var selectedConfiguration
var configurationHead: int

#moving blocks
var movingBlocks: bool
var blockLifted: Block

#saving
var sessionWorldChanges: Array[SessionWorldChange]
var worldChanges:Array[SessionWorldChange]

#other
@onready var miningDebug: PackedScene = preload("res://MiscScenes/mining_debug.tscn")


func _enter_tree():
	Global.worldManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeGrid()
	#Global.saveManager.Subscribe(self)
	pass # Replace with function body.

func LoadDevMode(seed):
	await get_tree().create_timer(0.1).timeout
	SetMiningValues(seed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#print(delta)
	
	if placingBlock:
		
		var array = WorldToGrid(Global.mouseManager.GetMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			StopPlacingBlock()
	
		if Input.is_action_just_pressed("mouse1"):
			
			PlayerPlaceBlock()
			
		if blockBeingPlaced.configurations.size() > 0: # has many configurations
			
			if Input.is_action_just_pressed("mouse_wheel_up"):
				configurationHead = configurationHead - 1
				if configurationHead < -1:
					configurationHead = blockBeingPlaced.configurations.size()-1
				UpdateConfiguration()
				
			if Input.is_action_just_pressed("mouse_wheel_down"):
				configurationHead = configurationHead + 1
				if configurationHead > blockBeingPlaced.configurations.size()-1:
					configurationHead = -1
				UpdateConfiguration()
			
	if movingBlocks:
		
		var array = WorldToGrid(Global.mouseManager.GblocketMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			blockLifted = null
			StopMovingBlocks()
			
		if Input.is_action_just_pressed("mouse1"):
			if blockLifted == null:
				var node: GridNode = GetNodeAt(array[0], array[1])
				if node.block == null || node.block.immovable:
					return
				blockLifted = node.block
				Global.gridSelect.texture = Global.gridSelect.sprites[2]
				
			else:
				#moving block
				var node: GridNode = GetNodeAt(array[0], array[1])
				if node.block != null:
					return
				NewSessionWorldChange(blockLifted.xGridPos, blockLifted.yGridPos,"")
				RemoveBlock(blockLifted.xGridPos, blockLifted.yGridPos)
				blockLifted.Remove()
				ForcePlaceBlock(blockLifted, array[0], array[1])
				NewSessionWorldChange(array[0], array[1],blockLifted.blockName)
				blockLifted = null
				Global.gridSelect.texture = Global.gridSelect.sprites[1]
				
				
		
	if !movingBlocks && !placingBlock:
		
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
	Global.gridSelect.modulate = Color.AQUA
	Global.gridSelect.visible = true
	pass
	
func StopPlacingBlock():
	placingBlock = false
	Global.hud.visible = true
	Global.gridSelect.visible = false

func StartMovingBlocks():
	if movingBlocks == true:
		return
	movingBlocks = true
	Global.gameManager.CloseAllWindows()
	Global.hud.visible = false
	Global.gridSelect.texture = Global.gridSelect.sprites[1]
	Global.gridSelect.visible = true

func StopMovingBlocks():
	movingBlocks = false
	Global.hud.visible = true
	Global.gridSelect.visible = false
	
func PlayerPlaceBlock():
	
	var mousePosition: Vector2 = Global.mouseManager.GetMousePosition()
	
	var gridPosition = WorldToGrid(mousePosition)
	var node = GetNodeAt(gridPosition[0], gridPosition[1])
	if node == null || node.block != null: #position already occupied
		print("Already occupied or outside of the map")
		return
	
	var i:int = 0 
	var array: Array[ResourceTuple]
	for component in blockBeingPlaced.components:
		var tuple = Global.resourceManager.NewResourceTuple(component,blockBeingPlaced.componentAmounts[i],false)
		array.push_back(tuple)
		i = i + 1
		
	if !Global.inventoryMenu.RequireResources(array, true) && !Global.gameManager.devMode:
		Global.effectManager.DisplayStatusIcon(Global.player.global_position,11)
		return
	
	var block = blockBeingPlaced.duplicate()
	PlaceBlock(block,gridPosition[0],gridPosition[1])
	
	NewSessionWorldChange(gridPosition[0], gridPosition[1], block.blockName)
	
func UpdateConfiguration():
	if configurationHead == -1: #select the base block
		Global.gridSelect.texture = blockBeingPlaced.menuIcon
		Global.gridSelect.modulate = Color.AQUA
		return
	
	
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
			var value1:float = noise.get_noise_2d(x*4, y*5) / 2
			var value2:float = noise.get_noise_2d((x-1000)*5, (y-1000)*5) / 2
			var value:float = value1 + value2
			
			if value > 0: #generate rock
				var block = Global.buildMenu.GetBlockReferenceByName("Rock Block").duplicate()
				PlaceBlock(block, x, y)
			
			#await get_tree().create_timer(0.0).timeout
			
	pass
	
func ApplyChanges(saveData:SaveData):
	for node in grid:
		node.savingFlag = false
		pass
		
	for change in saveData.worldChanges:
		var node = GetNodeAt(change.x,change.y)
		if !node.savingFlag:
			node.savingFlag = true
			if change.status == "":
				continue
			var block = Global.buildMenu.GetBlockReferenceByName(change.status).duplicate()
			if block != null:
				ForcePlaceBlock(block,change.x,change.y)
		else:
			change.outOfDate = true 
	pass
	
#Saving
func NewSessionWorldChange(x:int, y:int, status: String):
	var new = SessionWorldChange.new()
	new.x = x
	new.y = y
	new.status = status
	sessionWorldChanges.push_front(new)
	pass
	
func Save(saveData:SaveData):
	
	for node in grid:
		node.savingFlag = false
		pass
	
	for change in sessionWorldChanges:
		var node = GetNodeAt(change.x, change.y)
		if !node.savingFlag:
			node.savingFlag = true
			saveData.worldChanges.push_front(change)
	
	
	pass
	
func Load(saveData:SaveData):
	print("World manager loading...")
	#Apply seed
	SetMiningValues(saveData.seed)
	GenerateNaturalBlocks(saveData.seed)
	
	#Apply changes
	ApplyChanges(saveData)
	pass
