extends Node2D
class_name GameManager

@export var devMode: bool
@onready var camera: Camera2D = $Camera2D
var rng: RandomNumberGenerator
var gameActive: bool
@onready var miningDebug: PackedScene = preload("res://MiscScenes/mining_debug.tscn")

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
	
func StartNewGame(seed: String):
	if gameActive:
		return
	
	gameActive = true	
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	Global.worldManager.LoadWorld(seed)
	
	Global.hud.OpenHUD()
	pass

func StartInDevMode(seed: String):
	if gameActive:
		return
	
	gameActive = true	
	
	if seed == "":
		seed = str(randf_range(-100000.0, 100000.0))
	
	rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	Global.worldManager.LoadDevMode(seed)
	
	Global.hud.OpenHUD()
	pass

func ReturnToMainMenu(): #OBS
	get_tree().reload_current_scene()
	pass


	

#UI
func CloseAllWindows():
	Global.buildMenu.visible = false
	pass
	
func IsWindowOpen()->bool:
	if Global.buildMenu.visible:
		return true
		
	return false
