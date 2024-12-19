extends Node2D
class_name ProjectilePool

@export var baseProjectile : PackedScene
@export var poolSize : int

var initialized: bool
var pool: Array[Projectile]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	InitializePool()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func InitializePool():
	
	for i in poolSize:
		var instance: Projectile = baseProjectile.instantiate()
		instance.pool = self
		Global.gameManager.add_child(instance)
		instance.name = baseProjectile._bundled.get("names")[0]
		instance.visible = false
		ReturnToPool(instance)
		pass
	
	initialized = true
	
	pass
	
func ReturnToPool(projectile:Projectile):
	projectile.shot = false
	pool.push_back(projectile)
	pass
	
func PopFromPool()->Projectile:
	var projectile = pool.pop_front()
	#print(pool.size())
	return projectile
	pass
