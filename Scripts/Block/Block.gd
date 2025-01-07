extends Node2D
class_name Block

@export var blockName: String
@export var desc: String
@export var hp: int
@export var menuIcon: Texture2D
@export var canHoldResources: bool #can never hold resources
@export var visualsNode: Node2D #used for shaking
@export var immovable: bool
@export var _tags: Array[String]
@export var components: Array[String]
@export var componentAmounts: Array[int]

var placed:bool
var xGridPos:int
var yGridPos:int
var resourcesHeld: Array[_Resource]
var doesntAcceptResources: bool #can be turned on to prevent holding resources

#shake
var shakeMagnitude: float


func OnPlace():
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	for neighbor in neighbors:
		if neighbor != null && neighbor.block != null:
			neighbor.block.NeighborEntered(self)
	placed = true

func Remove(): #this doesnt mean that block is removed from the world just that its removed from this position
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	for neighbor in neighbors:
		if neighbor.block != null:
			neighbor.block.NeighborLeft(self)
			
	for resource in resourcesHeld:
		resource.Drop()
	
	placed = false
	

func Destroy():# removes block for good
	Global.worldManager.RemoveBlock(xGridPos,yGridPos)
	Remove()
	queue_free()
	
func CreepDamage(damage: int):
	
	hp = hp - damage
	
	if hp < 0:
		Destroy()
	
	pass

func ReceiveResource(resource: _Resource, source:Block):
	if resourcesHeld.size() >= 10:
		resource.Drop()
		return
	
	resource.ChangeHolder(self)
	resourcesHeld.push_back(resource)
	
		
func NeighborEntered(neighbor: Block): 
	#print("bruh")
	pass
	
func NeighborLeft(neighbor: Block):
	pass


func Shake():
	if visualsNode == null:
		return
	shakeMagnitude = 1.0
	visualsNode.position = Vector2(randf_range(-5.0, 5.0), randf_range(-5.0, 5.0))
	pass

func PlayerInteract():
	pass
