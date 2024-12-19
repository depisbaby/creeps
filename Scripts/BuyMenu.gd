extends Control
class_name BuyMenu

#rewards
@export var rewardIcons: Array[TextureRect]
var rewardBlocksPacked: Array[PackedScene]
var rewardBlocksInstances: Array[Node2D]
var selectingReward: bool
@onready var rewardWindow: Control = $Rewards

#utility shop
@onready var utilityShopWindow: Control = $UtilityShop

@export var commonBlocks: Array[PackedScene] = [
	
	#turrets
	preload("res://BlockScenes/Turrets/default_turret.tscn"),
	preload("res://BlockScenes/Turrets/twin_fire.tscn"),
	preload("res://BlockScenes/Turrets/little_purr.tscn")
	
]
@export var uncommonBlocks: Array[PackedScene] = [
	
	#turrets
	preload("res://BlockScenes/Turrets/default_turret.tscn"),
	preload("res://BlockScenes/Turrets/twin_fire.tscn"),
	preload("res://BlockScenes/Turrets/little_purr.tscn")
	
]
@export var rareBlocks: Array[PackedScene] = [
	
	#turrets
	preload("res://BlockScenes/Turrets/default_turret.tscn"),
	preload("res://BlockScenes/Turrets/twin_fire.tscn"),
	preload("res://BlockScenes/Turrets/little_purr.tscn")
	
]

@export var utilityShopBlocks: Array[PackedScene] = [
	preload("res://BlockScenes/conveyor_multi.tscn"),
	preload("res://BlockScenes/conveyor_up.tscn"),
	preload("res://BlockScenes/conveyor_right.tscn"),
	preload("res://BlockScenes/conveyor_down.tscn"),
	preload("res://BlockScenes/conveyor_left.tscn")
]

func _enter_tree():
	Global.buyMenu = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func CloseAllWindows():
	OpenRewardWindow(false)
	OpenUtilityShop(false)

#reward related
func NewRewards():
	
	for i in 3:
		var random = Global.gameManager.rng.randi_range(1, 20) #D20
		var instance: Node2D
		var packed: PackedScene
		
		if random < 14: #common
			var _random = Global.gameManager.rng.randi_range(0, commonBlocks.size()-1)
			packed = commonBlocks[_random]
			instance = commonBlocks[_random].instantiate()
			
			pass
		
		if random < 20: #uncommon
			var _random = Global.gameManager.rng.randi_range(0, uncommonBlocks.size()-1)
			packed = uncommonBlocks[_random]
			instance = uncommonBlocks[_random].instantiate()
			pass
			
		else: #rare
			var _random = Global.gameManager.rng.randi_range(0, rareBlocks.size()-1)
			packed = rareBlocks[_random]
			instance = rareBlocks[_random].instantiate()
			pass
		
		rewardBlocksInstances.push_back(instance)
		rewardBlocksPacked.push_back(packed)
		rewardIcons[i].texture = instance.menuIcon
	
	selectingReward = true
	OpenRewardWindow(true)
	pass

func OpenRewardWindow(open:bool):
	if open:
		if selectingReward == false:
			return
		rewardWindow.visible = true
	else :
		rewardWindow.visible = false

#utility shop related
func OpenUtilityShop(open:bool):
	if open:
		utilityShopWindow.visible = true
	else :
		utilityShopWindow.visible = false	
		
#events
func WaveStarted():
	selectingReward = false
	OpenRewardWindow(false)
	pass

#buttons

func _on_pick_1_button_down():
	if !selectingReward:
		return
		
	selectingReward = false
	OpenRewardWindow(false)
	
	await get_tree().create_timer(0.01).timeout
	Global.gameManager.StartPlacingBlock(rewardBlocksPacked[0], 0,rewardBlocksInstances[0].bundleAmount)
	rewardBlocksInstances[1].queue_free()
	rewardBlocksInstances[2].queue_free()
	rewardBlocksInstances.clear()
	rewardBlocksPacked.clear()
	
	pass # Replace with function body.

func _on_pick_2_button_down():
	if !selectingReward:
		return
	selectingReward = false
	
	OpenRewardWindow(false)
	await get_tree().create_timer(0.01).timeout
	
	Global.gameManager.StartPlacingBlock(rewardBlocksPacked[1],0,rewardBlocksInstances[1].bundleAmount)
	rewardBlocksInstances[0].queue_free()
	rewardBlocksInstances[2].queue_free()
	rewardBlocksInstances.clear()
	rewardBlocksPacked.clear()
	pass # Replace with function body.

func _on_pick_3_button_down():
	if !selectingReward:
		return
	selectingReward = false
	
	OpenRewardWindow(false)
	await get_tree().create_timer(0.01).timeout
	
	Global.gameManager.StartPlacingBlock(rewardBlocksPacked[2], 0, rewardBlocksInstances[2].bundleAmount)
	rewardBlocksInstances[1].queue_free()
	rewardBlocksInstances[0].queue_free()
	rewardBlocksInstances.clear()
	rewardBlocksPacked.clear()
	pass # Replace with function body.

func _on_utility_shop_close_button_down():
	OpenUtilityShop(false)
	pass # Replace with function body.

func _on_reward_close_button_down():
	OpenRewardWindow(false)
	pass # Replace with function body.

func _on_utility_buy_button_down(extra_arg_0):
	
	OpenRewardWindow(false)
	await get_tree().create_timer(0.01).timeout
	
	match extra_arg_0:
		0:
			Global.gameManager.StartPlacingBlock(utilityShopBlocks[0],5,-1)
			pass
		1:
			Global.gameManager.StartPlacingBlock(utilityShopBlocks[1],3,-1)
			pass
		2:
			Global.gameManager.StartPlacingBlock(utilityShopBlocks[2],3,-1)
			pass
		3:
			Global.gameManager.StartPlacingBlock(utilityShopBlocks[3],3,-1)
			pass
		4:
			Global.gameManager.StartPlacingBlock(utilityShopBlocks[4],3,-1)
			pass
	pass # Replace with function body.
