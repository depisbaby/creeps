extends Node2D
class_name EnemyManager

@export var enemies: Array[PackedScene] =[
	preload("res://EnemyScenes/mite.tscn") #0
]
var waveInProgress: bool
var playerSize: float
var currentWave:int = 1

#per wave properties
var totalNumOfCreeps: int
var creepsKilled: int

func _enter_tree():
	Global.enemyManager = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#StartWave(100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func StartWave(waveNumberOverride: int):
	
	if waveInProgress:
		return
	waveInProgress = true
	
	if waveNumberOverride != 0:
		currentWave = waveNumberOverride
	
	var waveNumber = currentWave
	
	var spawnPlan :Array[int]
	
	var numberOfMites:int = waveNumber * (2 + waveNumber*0.1)
	
	for i in numberOfMites: #insert amount of mites
		spawnPlan.push_back(0)
	
	spawnPlan.shuffle()
	totalNumOfCreeps = spawnPlan.size()
	creepsKilled = 0
	
	while(true):
		
		var pick = spawnPlan.pop_front() #spawn enemy
		var instance = enemies[pick].instantiate()
		add_child(instance)
		instance.name = enemies[pick]._bundled.get("names")[0]
		
		#adjust stats according to wave
		instance.speed = instance.speed + waveNumber * 0.2 + randf_range(-3.0, 3.0)
		instance.hp = instance.hp + floor(waveNumber * 0.1)
		
		#spawn position
		var randomVector = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		var randomPosition = Global.gameManager.heartBlock.global_position + randomVector * (playerSize + 300)
		instance.global_position = randomPosition
		
		instance.visible = true
		instance.alive = true
		
		Global.console.debugText.text = str("number of mites: ",numberOfMites," speed: ",instance.speed," hp: ", instance.hp)
		
		await get_tree().create_timer(clamp(0.5 - waveNumber* 0.01, 0.1, 1.0)).timeout
		
		if spawnPlan.size() == 0:
			break
		
		
		

#events
func PlayerExpanded(distance: float):
	if distance > playerSize:
		playerSize = distance
	pass
	
func CreepKilled():
	creepsKilled = creepsKilled + 1
	if creepsKilled >= totalNumOfCreeps:
		WaveCompleted()

func WaveCompleted():
	Global.gameManager.WaveCompleted(currentWave)
	currentWave = currentWave + 1
	waveInProgress = false
	pass
	
