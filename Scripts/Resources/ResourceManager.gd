extends Node
class_name ResourceManager

@export var baseScene : PackedScene
@export var poolSize : int

var initialized: bool
var pool: Array[_Resource]
var allInstances: Array[_Resource]

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

var debugHead:int

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
	
	ScaleUpThePool()
	
	initialized = true
	
	pass

func ReturnToPool(instance:_Resource):
	
	#reset values
	instance.visible = false
	instance.global_position = Vector2.ZERO
	
	instance.holder = null
	instance.holderOffset = Vector2.ZERO
	instance.outOfPool = false
	instance.movingCooldown = 0
	

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
	for i in poolSize:
		var instance: _Resource = baseScene.instantiate()
		add_child(instance)
		instance.name = str("resource_",debugHead)
		instance.debug.text = str(debugHead)
		instance.visible = false
		allInstances.push_back(instance)
		ReturnToPool(instance)
		debugHead = debugHead +1
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

func Save():
	var loadedData = Global.saveManager.loadedWorldData
	loadedData.outOfPoolResources.clear()
	for resource in allInstances:
		if pool.has(resource):
			continue
		
		var rSD :ResourceSaveData = ResourceSaveData.new()
		rSD.x = resource.holder.xGridPos
		rSD.y = resource.holder.yGridPos
		rSD.resourceName =resource.resourceName
		loadedData.outOfPoolResources.push_back(rSD)
		
			
	pass
	
func Load():
	var loadedData = Global.saveManager.loadedWorldData
	
	for rSD in loadedData.outOfPoolResources:
		var block:Block = Global.worldManager.GetNodeAt(rSD.x, rSD.y).block
		var resource: _Resource = PopFromPoolWithName(rSD.resourceName)
		resource.global_position = Global.worldManager.GridToWorld(rSD.x, rSD.y)
		block.ReceiveResource(resource,null)
	
	pass
	
	
