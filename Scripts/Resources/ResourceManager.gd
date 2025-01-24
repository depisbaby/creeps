extends Node
class_name ResourceManager

@export var baseScene : PackedScene
@export var poolSize : int

var initialized: bool
var pool: Array[_Resource]
var allInstances: Array[_Resource]
var notDefinedTu

var resourceLibrary:Array[ResourceTuple] = [
	preload("res://Resources/Resources/error.tres"),
	preload("res://Resources/Resources/element_vk.tres"),#2
	preload("res://Resources/Resources/mean_looking_crystals.tres"),#3
	preload("res://Resources/Resources/pseudo_iron.tres"),#5
	preload("res://Resources/Resources/purplutide.tres"),#6
	preload("res://Resources/Resources/smooth_stuff.tres"),#10
	preload("res://Resources/Resources/volcanite.tres"),#11
	preload("res://Resources/Resources/wonksten.tres"),#12
	preload("res://Resources/Resources/oil.tres"),#4
	preload("res://Resources/Resources/conveyor_kit.tres"),#0
	preload("res://Resources/Resources/drill_bit.tres"),#1
	preload("res://Resources/Resources/simple_components.tres"),#7
	preload("res://Resources/Resources/simple_circuit.tres"),#8
	preload("res://Resources/Resources/simple_motor.tres"),#12
	preload("res://Resources/Resources/log.tres"),#12
	preload("res://Resources/Resources/mess.tres"),
	preload("res://Resources/Resources/wire.tres"),
	preload("res://Resources/Resources/conductive_plating.tres"),
	preload("res://Resources/Resources/PE_sensor.tres"),
	preload("res://Resources/Resources/tinkerer_kit.tres"),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	
	
	
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
	instance.dropped = false
	instance.dropAnimTime = 0.0

	pool.push_back(instance)
	
	pass
	
func PopFromPoolWithId(id:int)->_Resource:
	
	var instance:_Resource = pool.pop_front()
	if instance == null:
		print("hep")
		ScaleUpThePool()
		return PopFromPoolWithId(id)
	instance.resourceName = resourceLibrary[id].resourceName
	instance.texture = resourceLibrary[id].texture
	instance.outOfPool = true
	instance.visible = true
	return instance
	pass
	
func PopFromPoolWithName(name: String)->_Resource:
	
	var instance:_Resource = pool.pop_front()
	if instance == null:
		print("hep")
		ScaleUpThePool()
		return PopFromPoolWithName(name)
	
	var result: ResourceTuple = GetResourceByName(name)
	
	if result == null:
		print("invalid resource name, '",name,"'")
	
	instance.resourceName = result.resourceName
	instance.texture = result.texture
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
		
func GetResourceByName(name:String)->ResourceTuple:
	for resource in resourceLibrary:
		if resource.resourceName == name:
			return resource
			
	return resourceLibrary[0]
	
func NewResourceTuple(resourceName:String, amount:int, withTexture:bool)->ResourceTuple:
	var tuple = ResourceTuple.new()
	tuple.resourceName = resourceName
	tuple.amount = amount
	if withTexture:
		tuple.texture = GetResourceByName(resourceName).texture
	return tuple

	
	
