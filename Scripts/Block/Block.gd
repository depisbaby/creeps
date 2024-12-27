extends Node2D
class_name Block

@export var blockName: String
@export var desc: String
@export var hp: int
@export var menuIcon: Texture2D
@export var canHoldResources: bool
@export var visualsNode: Node2D #used for shaking
@export var bundleAmount: int

var placed:bool
var xGridPos:int
var yGridPos:int
var resourcesHeld: Array[_Resource]

#shake
var shakeMagnitude: float

func _init():
	if bundleAmount == 0:
		bundleAmount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if !placed:
		return

func _process(delta):
	if !placed:
		return
		
	if shakeMagnitude > 0.0:
		visualsNode.position = lerp(visualsNode.position, Vector2(0,0), delta* 10)
		shakeMagnitude = shakeMagnitude - delta

func _exit_tree():
	
	pass

func OnPlace():
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	for neighbor in neighbors:
		if neighbor.block != null:
			neighbor.block.NeighborEntered(self)
	placed = true

func OnDestroy():
	Global.gameManager.RemoveBlockFromGrid(xGridPos,yGridPos)
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	for neighbor in neighbors:
		if neighbor.block != null:
			neighbor.block.NeighborLeft(self)
	
	for resource in resourcesHeld:
		Global.resourceManager.ReturnToPool(resource)
	
	queue_free()
	
func CreepDamage(damage: int):
	
	hp = hp - damage
	
	if hp < 0:
		OnDestroy()
	
	pass

func ReceiveResource(resource: _Resource, source:Block):
	resource.ChangeHolder(self)
	resourcesHeld.push_back(resource)
	
		
func NeighborEntered(neighbor: Block): 
	pass
	
func NeighborLeft(neighbor: Block):
	pass

func WaveStarted():
	
	pass

func WaveCompleted():
	if resourcesHeld.size() > 0:
		resourcesHeld.clear()
	pass

func Shake():
	if visualsNode == null:
		return
	shakeMagnitude = 1.0
	visualsNode.position = Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	pass
