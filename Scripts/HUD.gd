extends Control
class_name HUD

func _enter_tree():
	Global.hud = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func UsabilityCheck()-> bool:
	if Global.worldManager.placingBlock || Global.worldManager.movingBlocks:
		return false
	return true
	
func OpenHUD():
	visible = true

func _on_move_block_button_down():
	if !UsabilityCheck():
		return
	await get_tree().create_timer(0.1).timeout
	Global.worldManager.StartMovingBlocks()
	pass # Replace with function body.


func _on_demolish_block_button_down():
	pass # Replace with function body.


func _on_build_menu_button_down():
	if !UsabilityCheck():
		return
	await get_tree().create_timer(0.1).timeout
	Global.buildMenu.OpenView()
	pass # Replace with function body.


func _on_inventory_button_down():
	if !UsabilityCheck():
		return
	await get_tree().create_timer(0.1).timeout
	Global.inventoryMenu.OpenView()
	pass # Replace with function body.


func _on_construction_manual_button_down():
	if !UsabilityCheck():
		return
	await get_tree().create_timer(0.1).timeout	
	Global.constructionManual.OpenView()
	pass # Replace with function body.


func _on_exit_button_down():
	Global.gameManager.ReturnToMainMenu()
	pass # Replace with function body.
