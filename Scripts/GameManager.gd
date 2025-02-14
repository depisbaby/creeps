extends Node2D
class_name GameManager

@export var devMode: bool
@onready var camera: Camera2D = $Camera2D
var rng: RandomNumberGenerator
var gameActive: bool
@onready var miningDebug: PackedScene = preload("res://MiscScenes/mining_debug.tscn")
@onready var loadingScreen: Control = $CanvasLayer/LoadingScreen
@onready var loadingScreenText: Label = $CanvasLayer/LoadingScreen/Label

#game

var tick:int = 1


func _enter_tree():
	Global.gameManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	tick = tick + 1
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func StartNewGame(seed:String, slot: int):
	print("2afdasf")
	if gameActive:
		return
	
	gameActive = true	
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	loadingScreen.visible = true
	Global.mainMenu.visible = false
	
	await  get_tree().create_timer(0.1).timeout
	
	await Global.saveManager.StartNewGame(seed,slot)
	
	GiveStartingItems()
	Global.constructionManual.LoadRecipes()
	
	var node = Global.worldManager.GetEmpty(Global.worldManager.gridSize/2,Global.worldManager.gridSize/2)
	Global.player.Teleport(Vector2(node.x*32, node.y*32))
	
	loadingScreen.visible = false
	
	Global.hud.OpenHUD()
	
	pass

func StartInDevMode(seed: String):
	if gameActive:
		return
	
	gameActive = true	
	
	devMode = true
	Global.buildMenu.EnterInDevMode()
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	Global.worldManager.LoadDevMode(seed)
	Global.constructionManual.LoadRecipes()
	
	Global.hud.OpenHUD()
	pass

func ReturnToMainMenu(): #OBS
	loadingScreen.visible = true
	Global.saveManager.SaveGame()
	get_tree().reload_current_scene()
	pass

func LoadGame(slot:int):
	if gameActive:
		return
	
	gameActive = true	
	
	loadingScreen.visible = true
	Global.mainMenu.visible = false
	
	await  get_tree().create_timer(0.1).timeout
	
	await Global.saveManager.LoadGame(slot,"")
	
	Global.buildMenu.GetUnlockedBlocks()
	Global.constructionManual.LoadRecipes()
	
	loadingScreen.visible = false
	
	Global.hud.OpenHUD()
	pass

func GiveStartingItems():
	
	
	
	Global.buildMenu.UnlockBlock("Conveyor Block (up)")
	Global.buildMenu.UnlockBlock("Miner Block")
	Global.buildMenu.UnlockBlock("Tinkerer Block")
	Global.buildMenu.UnlockBlock("Chest Block")
	
	#for chest block
	Global.inventoryMenu.GiveResource("Log",5)
	
	#for tinkerer block
	Global.inventoryMenu.GiveResource("Tinkerer Kit",1)
	
	#for miner block
	var amountOfMiners= 5
	Global.inventoryMenu.GiveResource("Drill Bit",1*amountOfMiners)
	Global.inventoryMenu.GiveResource("Simple Motor",5*amountOfMiners)
	Global.inventoryMenu.GiveResource("Simple Components",4*amountOfMiners)
	
	#for conveyors
	var amountOfConveyors= 5
	Global.inventoryMenu.GiveResource("Conveyor Kit",1*amountOfConveyors)
	
	
	pass

#UI
func CloseAllWindows():
	Global.buildMenu.visible = false
	pass
	
func IsWindowOpen()->bool:
	if Global.buildMenu.visible:
		return true
		
	return false

func SetLoadingScreenText(text:String):
	loadingScreenText.text = text
	pass
