extends Block

@export var damage: int
@export var attackSpeed: float
@export var projectileSpeed: float
@export var accuracy: float
@export var range: CollisionShape2D
@export var multishot: int
@export var sizeMod: int 

@export var projectilePool: ProjectilePool
@export var turretHead: Node2D

var targetList: Array[Creep]
var target: Creep
var tasking: bool

func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	
	if !placed:
		return
	
	if target != null && !tasking:
		ShootAtTarget(target)
		pass
		
	if target == null && targetList.size() > 0:
		
		for _target in targetList:
			if _target == null:
				continue
			
			target = _target
		
		pass
	
	pass
	
func _physics_process(delta):
	
	if target != null:
		turretHead.look_at(target.global_position)
	

func ShootAtTarget(target: Creep):
	tasking = true
	
	var projectile = projectilePool.PopFromPool()
	if projectile == null: #pool empty
		tasking = false
		return
		
	projectile.global_position = global_position
	projectile.visible = true
	var direction = (target.global_position - global_position) + Vector2(randf_range(-1.0, 1.0)*accuracy,randf_range(-1.0, 1.0)*accuracy)
	
	projectile.Shoot(
		direction, 
		projectileSpeed, 
		damage, 
		multishot, 
		sizeMod)
	
	await get_tree().create_timer(attackSpeed).timeout
	tasking = false
	pass


func _on_radar_area_entered(area):
	if area.get_parent() is Creep:
		targetList.push_front(area.get_parent())
		pass
	pass # Replace with function body.
