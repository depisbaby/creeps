extends Node2D
class_name Creep

@export var speed: float
@export var damage: int
@export var attackSpeed: float
@export var hp: int

var moveDirection: Vector2
var targetBlock: Block
var tasking: bool
var alive: bool
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !alive:
		return
	
	if Global.gameManager.heartBlock != null:
		moveDirection = (Global.gameManager.heartBlock.global_position - global_position).normalized()
	
	if targetBlock != null && !tasking:
		Attack()
		pass
	if !tasking:
		Move(delta)
	pass

func Move(delta):
	global_position = global_position + moveDirection * delta * speed
	pass

func Attack():
	tasking = true
	targetBlock.CreepDamage(damage)
	
	timer.start(attackSpeed)
	await timer.timeout
	
	tasking = false
	pass

func DamageThis(damage: int):
	if !alive:
		return
	#print(name, ": Damage taken")
	hp = hp - damage
	if hp <= 0:
		OnDeath()
	pass

func OnDeath():
	alive = false
	Global.enemyManager.CreepKilled()
	queue_free()
	pass

func _on_area_2d_area_entered(area):
	if area.get_parent() is Block:
		targetBlock = area.get_parent()
		pass
	pass # Replace with function body.
