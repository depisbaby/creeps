extends Node2D
class_name GameManager

@export var devMode: bool
@onready var camera: Camera2D = $Camera2D
var rng: RandomNumberGenerator
var gameActive: bool

#game
var heartBlock: Block
@onready var heartBlockScene =preload("res://BlockScenes/heart_block.tscn")
var waveInProgress: bool
var coins:int
var tick:int = 1
var placedBlocks: Array[Block]

#placing blocks
var placingBlock: bool
var blockBeingPlaced: PackedScene
var blockBeingPlacedCost: int
var blockBeingPlacedAmount: int

#block grid
@export var gridSize: int
@export var blockSize: int
var grid: Array[GridNode]

@onready var miningDebug = preload("res://BlockScenes/mining_debug.tscn")

func _enter_tree():
	Global.gameManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	InitializeGrid()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if waveInProgress == true:
		tick = tick + 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#print(delta)
	
	if placingBlock:
		
		var array = WorldToGrid(Global.mouseManager.GetMousePosition())
		Global.gridSelect.global_position = GridToWorld(array[0], array[1])
		
		if Input.is_action_just_pressed("mouse2"):
			StopPlacingBlock()
	
		if Input.is_action_just_pressed("mouse1"):
			if Global.buyMenu.utilityShopWindow.visible:
				return
			if Global.buyMenu.rewardWindow.visible:
				return
			PlaceBlock()
	
	pass
	
func StartNewGame(seed: String):
	if gameActive:
		return
	
	gameActive = true	
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	SetMiningValues(seed)
	
	var newHeartBlock = heartBlockScene.instantiate()
	newHeartBlock.name = "heart_block"
	heartBlock = newHeartBlock
	add_child(newHeartBlock)
	ForcePlaceBlock(newHeartBlock,gridSize/2, gridSize/2)
	
	Global.buyMenu.NewRewards()
	pass

#events
func GameOver():
	get_tree().reload_current_scene()
	pass

func StartWave():
	if waveInProgress:
		return
	waveInProgress = true
	Global.buyMenu.WaveStarted()
	Global.enemyManager.StartWave(0)	
	Global.resourceManager.WaveStarted()
	
	for block in placedBlocks:
		block.WaveStarted()

func WaveCompleted(waveNumber: int):
	Global.buyMenu.NewRewards()
	Global.resourceManager.WaveCompleted()
	
	for block in placedBlocks:
		block.WaveCompleted()
	
	waveInProgress = false
	pass
	
#placing blocks
func StartPlacingBlock(block: PackedScene, _cost:int, _amount:int):
	placingBlock = true
	blockBeingPlacedCost = _cost
	blockBeingPlaced = block
	blockBeingPlacedAmount = _amount
	Global.buyMenu.CloseAllWindows()
	Global.hud.visible = false
	Global.gridSelect.visible = true
	pass
	
func StopPlacingBlock():
	placingBlock = false
	Global.hud.visible = true
	Global.gridSelect.visible = false
	
func PlaceBlock():
	
	if blockBeingPlacedCost > coins && !devMode:
		print("Not enough coins")
		return
	
	var mousePosition: Vector2 = Global.mouseManager.GetMousePosition()
	
	var gridPosition = WorldToGrid(mousePosition)
	var node = GetNodeAt(gridPosition[0], gridPosition[1])
	if node == null || node.block != null: #position already occupied
		print("Already occupied or outside of the map")
		return
	
	var block = blockBeingPlaced.instantiate()
	
	SetBlockAt(block, gridPosition[0], gridPosition[1])
	block.xGridPos = gridPosition[0]
	block.yGridPos = gridPosition[1]
	
	var worldPosition = GridToWorld(gridPosition[0], gridPosition[1])
	add_child(block)
	block.name = block.blockName
	block.global_position = worldPosition
	block.OnPlace()
	block.placed = true
	placedBlocks.push_back(block)
	
	Global.enemyManager.PlayerExpanded((worldPosition - heartBlock.global_position).length())
	
	coins = coins - blockBeingPlacedCost
	
	if blockBeingPlacedAmount != 1:
		blockBeingPlacedAmount = blockBeingPlacedAmount - 1
		
	else:
		StopPlacingBlock()
		print("done placing block(s)")
		
	pass

func ForcePlaceBlock(block:Block, x:int, y:int):
	if GetNodeAt(x, y).block != null: #position already occupied
		print("Already occupied")
		return
	var worldPosition = GridToWorld(x, y)
	SetBlockAt(block, x, y)
	block.xGridPos = x
	block.yGridPos = y
	block.global_position = worldPosition
	block.OnPlace()
	placedBlocks.push_back(block)
	
	pass

func RemoveBlockFromGrid(x:int, y:int):
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

func SetMiningValues(seed: String):
	var miningNoise: FastNoiseLite = FastNoiseLite.new()
	miningNoise.seed = hash(seed)
	for y in gridSize:
		for x in gridSize:
			var i = x + y*gridSize
			var value = miningNoise.get_noise_2d(x*6, y*6)
			#
			#var debug:Node2D = miningDebug.instantiate()
			#add_child(debug)
			#debug.global_position = GridToWorld(x,y)
			#if value < -0.15:
			#	debug.modulate = Color.GREEN
			#elif value > -0.01 && value < 0.01:
			#	debug.modulate = Color.AQUA
			#elif value < 0.15:
			#	debug.modulate = Color.NAVY_BLUE
				
			#else:
			#	debug.modulate = Color.RED
				
			grid[i].miningValue = value
	
	
	pass

func SetBlockAt(block:Block, x: int, y: int):
	var i = x + y*gridSize
	
	var _block = grid[i].block #check if theres a block and delete it
	if _block != null:
		_block.queue_free()
	
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
	
