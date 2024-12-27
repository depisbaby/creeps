extends Block

@export var damage: int
@export var attackSpeed: float
@export var projectileSpeed: float
@export var accuracy: float
@export var range: CollisionShape2D
@export var multiHit: int

@export var projectilePool: ProjectilePool
@export var turretHead: Node2D

var targetList: Array[Creep]
var target: Creep
var tasking: bool
var level : int
var levelCap : int

#stat modding
var damageMod: float 
var attackSpeedMod: float
var projectileSpeedMod: float
var accuracyMod: float
var rangeMod: float
var multiHitMod: float
var sizeMod: float

var modRetention: float



func _ready():
	canHoldResources = true
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
		
	if resourcesHeld.size() != 0:
		ReactWithResource(resourcesHeld.pop_front())
		

func WaveStarted():
	super.WaveStarted()
	
	level = 0
	levelCap = 10
	
	var _modRetention: float = clamp(modRetention,0.0,0.25)
	
	modRetention = 0
	damageMod = damageMod * _modRetention + 1
	attackSpeedMod = attackSpeedMod * _modRetention + 1
	projectileSpeedMod = projectileSpeedMod * _modRetention + 1
	accuracyMod = accuracyMod * _modRetention + 1 
	rangeMod = rangeMod * _modRetention + 1
	multiHitMod = multiHitMod * _modRetention + 1
	sizeMod = sizeMod * _modRetention + 1
	

func ShootAtTarget(target: Creep):
	tasking = true
	
	var projectile = projectilePool.PopFromPool()
	if projectile == null: #pool empty
		tasking = false
		return
		
	projectile.global_position = global_position
	projectile.visible = true
	var direction = (target.global_position - global_position).normalized() + Vector2(randf_range(-1.0, 1.0)*accuracy*accuracyMod,randf_range(-1.0, 1.0)*accuracy*accuracyMod)
	
	projectile.Shoot(
		direction, 
		clamp(projectileSpeed * projectileSpeedMod,50.0,1000.0), 
		clamp(damage * damageMod,0.0,1000000.0), 
		clamp(multiHit * multiHitMod, 1, 100), 
		clamp(sizeMod, 0, 10.0)
		)
		
	await get_tree().create_timer(clamp(attackSpeed * attackSpeedMod,0.10, 60.0)).timeout
	tasking = false
	pass


func _on_radar_area_entered(area):
	if area.get_parent() is Creep:
		targetList.push_front(area.get_parent())
		pass
	pass # Replace with function body.

func ReactWithResource(resource:_Resource):
	
	if level == levelCap:
		return
	
	match resource.resourceName:
		"brass":
			accuracyMod = accuracyMod - 0.01
			pass
		"gun_powder":
			projectileSpeedMod = projectileSpeedMod + 1
			pass
		"oil":
			attackSpeedMod = attackSpeedMod - 0.01
			pass
	
	level = level + 1		
	
	Global.resourceManager.ReturnToPool(resource)
	pass
