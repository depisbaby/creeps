extends Camera2D

var xSpeed:float
var ySpeed:float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	xSpeed = 0
	ySpeed = 0
	
	if Input.is_action_pressed("right"):
		xSpeed = 300
	if Input.is_action_pressed("left"):
		xSpeed = -300
	if Input.is_action_pressed("up"):
		ySpeed = -300
	if Input.is_action_pressed("down"):
		ySpeed = 300
	
	global_position = global_position + Vector2(xSpeed* delta, ySpeed* delta)
	
	pass
