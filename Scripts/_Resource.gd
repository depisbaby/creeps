extends Sprite2D
class_name _Resource

@export var resourceName: String

var holder: Block
var outOfPool: bool
var movingCooldown:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#scale = Vector2(0,0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !outOfPool:
		return
	
	if holder != null:
		global_position = lerp(global_position, holder.global_position,delta*5)
	
	pass

func _physics_process(delta: float) -> void:
	if movingCooldown > 0:
		movingCooldown = movingCooldown - 1


	
func ChangeHolder(block:Block):
	holder = block
	movingCooldown = 1
	
