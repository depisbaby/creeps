extends Label
class_name TextMessage

@onready var timer: Timer = $Timer

var targetPosition: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func _physics_process(delta):
	if visible:
		global_position = lerp(global_position, targetPosition, delta*2)
	
func Play():
	targetPosition = global_position + Vector2(0,-10)
	visible = true
	
	timer.start(1)
	await timer.timeout
	
	visible = false
	queue_free()
	
	
