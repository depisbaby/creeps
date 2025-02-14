extends CharacterBody2D
class_name Player

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed:float = 200
var xSpeed:float
var ySpeed:float

var tick:int

func _enter_tree():
	Global.player = self
	
	Global.saveManager.Subscribe(self)
	pass

func _physics_process(delta):
	tick = tick + 1
	if tick % 15 == 0 && (xSpeed != 0 || ySpeed != 0):
		Global.soundManager.PlayFootSteps()
	
	xSpeed = 0
	ySpeed = 0
	
	if Input.is_action_pressed("right"):
		xSpeed = 150
	if Input.is_action_pressed("left"):
		xSpeed = -150
	if Input.is_action_pressed("up"):
		ySpeed = -150
	if Input.is_action_pressed("down"):
		ySpeed = 150
	
	global_position = global_position + Vector2(xSpeed, ySpeed).normalized() *speed * delta
	
	move_and_slide()
	Animations()
	
func Save():
	var save = Global.saveManager.loadedWorldData
	save.playerPosition = global_position
	pass
	
func Load():
	var save = Global.saveManager.loadedWorldData
	global_position = save.playerPosition
	pass
	
func Animations():
	if (xSpeed != 0 || ySpeed != 0):
		
		if anim.animation != "walk":
			anim.play("walk")
	else :
		if anim.animation != "idle":
			anim.play("idle")
	
	if (xSpeed < 0):
		anim.flip_h = false
	elif (xSpeed > 0):
		anim.flip_h = true
			
	pass
	
func Teleport(position: Vector2):
	global_position = position
	pass
