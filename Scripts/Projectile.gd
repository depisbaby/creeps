extends Node2D
class_name Projectile

@export var sprite: Sprite2D
@export var colors: Array[Color]

var damage: int
var shot: bool
var velocity: Vector2
var lastFramePosition: Vector2
var pool: ProjectilePool

var colorTick: int
var lifeTick:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if shot:
		Move(delta)
	
	pass
	
func _physics_process(delta):
	colorTick = colorTick + 1
	if colorTick == 3:
		colorTick = 0
	
	sprite.modulate = colors[colorTick]
	
	lifeTick = lifeTick - 1
	if lifeTick < 0:
		Expire()


func Shoot(
direction: Vector2, 
speed: float, 
_damage: int,
multiShot:int,
sizeMod:float):
	velocity = direction.normalized() * speed
	damage = _damage
	lifeTick = 180
	shot = true
	
	pass

func Move(delta):
	global_position = global_position + velocity * delta
	
	pass

func HitCreep(target: Creep):
	shot = false
	target.DamageThis(damage)
	visible = false
	if pool != null:
		pool.ReturnToPool(self)
	else :
		queue_free()
	
	pass

func Expire():
	if !shot:
		return
	visible = false
	if pool != null:
		pool.ReturnToPool(self)
	else :
		queue_free()

func _on_area_2d_area_entered(area):
	if !shot:
		return
	if area.get_parent() is Creep:
		HitCreep(area.get_parent())
		pass
		
	pass # Replace with function body.
