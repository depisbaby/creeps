extends CharacterBody2D
class_name Player

var xSpeed:float
var ySpeed:float

func _enter_tree():
	Global.player = self
	
	Global.saveManager.Subscribe(self)
	pass

func _physics_process(delta):
	
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

	move_and_slide()
	
func Save(save:SaveData):
	save.playerPosition = global_position
	pass
	
func Load(save:SaveData):
	global_position = save.playerPosition
	pass
