extends AnimatedSprite2D
class_name Explosion

var tick:int

func _physics_process(delta: float) -> void:
	tick = tick - 1
	
	if tick == 0:
		Global.worldManager.ReturnToExplosionPool(self)
	pass
