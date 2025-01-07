extends Sprite2D
class_name _Resource

@export var resourceName: String

var holder: Block
var holderOffset: Vector2
var outOfPool: bool
var movingCooldown:int

#dropping anim
var dropAnimTime: float
var dropVelocity: Vector2
var dropped: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#scale = Vector2(0,0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !outOfPool:
		return
	
	if holder != null:
		global_position = lerp(global_position, holder.global_position+holderOffset,delta*5)
	
	if dropAnimTime > 0.0:
		dropVelocity = dropVelocity + Vector2(0,0.05)
		global_position = global_position + dropVelocity
		scale = clamp(scale - Vector2(0.01,0.01), Vector2.ZERO, Vector2.INF)
		dropAnimTime = dropAnimTime - delta
	elif dropped:
		dropped = false
		Global.resourceManager.ReturnToPool(self)
		scale = Vector2(1,1)
	pass

func _physics_process(delta: float) -> void:
	if movingCooldown > 0:
		movingCooldown = movingCooldown - 1


	
func ChangeHolder(block:Block):
	holder = block
	if holder.resourcesHeld.size() > 1:
		holderOffset = Vector2(randf_range(-10.0,10.0),randf_range(-10.0,10.0))
	else:
		holderOffset = Vector2.ZERO
	movingCooldown = 1
	
	
func Drop():
	holder = null
	dropAnimTime = 0.5
	dropVelocity = Vector2(randf_range(-1.0,1.0), randf_range(-1.0, -0.5)).normalized() * 2
	dropped = true
	pass
	
