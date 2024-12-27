extends Node
class_name ResourceManager

@export var baseScene : PackedScene
@export var poolSize : int

var initialized: bool
var pool: Array[_Resource]
var allInstances: Array[_Resource]
var waveInProgress: bool


var sprites:Array[Texture2D] = [
	preload("res://Sprites/Resources/brass_ore.png"),#0
	preload("res://Sprites/Resources/gun_powder.png"),#1
	preload("res://Sprites/Resources/oil.png")#2
	
]

func _enter_tree() -> void:
	Global.resourceManager = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InitializePool()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func InitializePool():
	
	for i in poolSize:
		var instance: _Resource = baseScene.instantiate()
		add_child(instance)
		instance.name = baseScene._bundled.get("names")[0]
		instance.visible = false
		allInstances.push_back(instance)
		ReturnToPool(instance)
		pass
	
	initialized = true
	
	pass

func ReturnToPool(instance:_Resource):
	instance.outOfPool = false
	instance.visible = false
	instance.holder = null
	instance.movingCooldown = 0

	pool.push_back(instance)
	
	pass
	
func PopFromPool(resourceName: String, spriteId: int)->_Resource:
	if !waveInProgress:
		return
	var instance:_Resource = pool.pop_front()
	if instance == null:
		print("hep")
		ScaleUpThePool()
		return PopFromPool(resourceName, spriteId)
	instance.resourceName = resourceName
	instance.texture = sprites[spriteId]
	instance.outOfPool = true
	instance.visible = true
	return instance
	pass
	
func ScaleUpThePool():
	for i in 100:
		var instance: _Resource = baseScene.instantiate()
		add_child(instance)
		instance.name = baseScene._bundled.get("names")[0]
		instance.visible = false
		allInstances.push_back(instance)
		ReturnToPool(instance)
		pass

func WaveStarted():
	waveInProgress = true
	pass

func WaveCompleted():
	print("print")
	waveInProgress = false
	for resource in allInstances:
		if resource.outOfPool:
			ReturnToPool(resource)
			
	pass
	
	
