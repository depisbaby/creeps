extends Node2D
class_name GameManager

@export var devMode: bool
@onready var camera: Camera2D = $Camera2D
var rng: RandomNumberGenerator
var gameActive: bool
@onready var miningDebug: PackedScene = preload("res://MiscScenes/mining_debug.tscn")
@onready var loadingScreen: Control = $CanvasLayer/LoadingScreen

#game

var tick:int = 1


func _enter_tree():
	Global.gameManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	tick = tick + 1
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func StartNewGame(seed:String, slot: int):
	if gameActive:
		return
	
	gameActive = true	
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	loadingScreen.visible = true
	Global.mainMenu.visible = false
	
	await  get_tree().create_timer(0.01).timeout
	
	Global.saveManager.StartNewGame(seed,slot)
	
	#starting items
	GiveStartingItems()
	
	print("loading done")
	loadingScreen.visible = false
	
	Global.hud.OpenHUD()
	pass

func StartInDevMode(seed: String):
	if gameActive:
		return
	
	gameActive = true	
	
	devMode = true
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	Global.worldManager.LoadDevMode(seed)
	
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
	
	await  get_tree().create_timer(0.01).timeout
	
	Global.saveManager.LoadGame(slot)
	print("loading done")
	loadingScreen.visible = false
	
	Global.hud.OpenHUD()
	pass

func GiveStartingItems():
	#for chest block
	Global.inventoryMenu.GiveResource("Log",5)
	
	#for tinkerer block
	Global.inventoryMenu.GiveResource("Simple Circuit",10)
	Global.inventoryMenu.GiveResource("Simple Motor",5)
	Global.inventoryMenu.GiveResource("Simple Components",25)
	
	#for miner block
	var amountOfMiners= 2
	Global.inventoryMenu.GiveResource("Drill Bit",1*amountOfMiners)
	Global.inventoryMenu.GiveResource("Simple Motor",15*amountOfMiners)
	Global.inventoryMenu.GiveResource("Simple Components",25*amountOfMiners)
	
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
