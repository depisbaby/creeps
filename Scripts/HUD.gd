extends Node
class_name HUD

func _enter_tree():
	Global.hud = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	if Global.gameManager.placingBlock:
		return
	Global.enemyManager.StartWave(0)
	pass # Replace with function body.


func _on_reward_button_down():
	if Global.gameManager.placingBlock:
		return
	Global.buyMenu.OpenRewardWindow(true)
	pass # Replace with function body.


func _on_utility_shop_button_down():
	if Global.gameManager.placingBlock:
		return
	Global.buyMenu.OpenUtilityShop(true)
	pass # Replace with function body.
