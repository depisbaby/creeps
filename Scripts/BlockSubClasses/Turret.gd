extends Block

@export var damage: int
@export var attackSpeed: float
@export var projectileSpeed: float
@export var accuracy: float
@export var range: int
@export var multiHit: int

@export var projectilePool: ProjectilePool
@export var turretHead: Node2D
@export var rangeCollider: CollisionShape2D

var targetList: Array[Creep]
var target: Creep
var tasking: bool
var level : int

#stat modding
var damageMod: float = 1
var attackSpeedMod: float = 1
var projectileSpeedMod: float = 1
var accuracyMod: float = 1
var rangeMod: float = 1
var multiHitMod: float = 1
var sizeMod: float = 0

var modRetention: float



func _ready():
	canHoldResources = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
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
		
func OnPlace():
	super.OnPlace()
	ResetMods()
	Global.effectManager.DisplayStatusIcon(global_position,level - 1)
	
	
	

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
		clamp(sizeMod, 0.0, 10.0)
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
	
	if level == 10:
		Global.resourceManager.ReturnToPool(resource)
		return
	
	match resource.resourceName:
		"accurium":
			accuracyMod = accuracyMod - 0.05
			pass
		"damagnite":
			damageMod = damageMod + 0.05
			pass
		"multsten":
			multiHitMod = multiHitMod + 0.10
			pass
		"rangium":
			rangeMod = rangeMod + 0.10
			pass
		"sizium":
			sizeMod = sizeMod + 0.05
			pass
		"speedium":
			attackSpeedMod = attackSpeedMod - 0.01
			pass
		"velocium":
			projectileSpeedMod = projectileSpeedMod + 0.10
			pass
	
	level = level + 1		
	
	if level == 10:
		doesntAcceptResources = true
	
	Global.effectManager.DisplayStatusIcon(global_position,level - 1)
	Global.resourceManager.ReturnToPool(resource)
	UpdateRange()
	pass
	
func UpdateRange():
	rangeCollider.shape.radius = range * rangeMod
	pass

func ResetMods():
	level = 1
	
	damageMod= 1
	attackSpeedMod= 1
	projectileSpeedMod= 1
	accuracyMod= 1
	rangeMod= 1
	multiHitMod= 1
	sizeMod= 0	
	
