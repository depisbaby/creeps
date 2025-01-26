extends Sprite2D
class_name _Resource

@export var resourceName: String
@onready var debug: Label = $Label

var holder: Block
var holderOffset: Vector2
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
		global_position = lerp(global_position, holder.global_position+holderOffset,delta*5)
		
		if (holder.global_position - global_position).length() > 100:
			modulate = Color.RED
			print("vittu")
			
		

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
	
	
