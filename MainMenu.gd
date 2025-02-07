extends Control
class_name MainMenu

@onready var saveSelect: Control =$SaveSelect
@onready var seed: LineEdit = $Seed

#slots
@onready var slots: Array[Control] = [$SaveSelect/Slot1,]
@onready var slotNameLabels: Array[Label] = [$SaveSelect/Slot1/slot_name,]
@onready var slotLoadViews:Array[Control] = [$SaveSelect/Slot1/LoadView]
@onready var slotNewGameViews:Array[Control] = [$SaveSelect/Slot1/NewGameView]
@onready var slotSeedFields:Array[LineEdit] = [$SaveSelect/Slot1/NewGameView/Seed]

func _enter_tree():
	Global.mainMenu = self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	saveSelect.visible = false
	
	pass # Replace with function body.


func LoadSave(slotNumber): #slot1 = 0
	print("loading")
	Global.gameManager.LoadGame(slotNumber)
	pass

func NewSave(slotNumber):
	print("new game")
	var seed = slotSeedFields[slotNumber].text
	Global.gameManager.StartNewGame(seed,slotNumber)
		
	pass
	
func DeleteSave(slotNumber):
	Global.saveManager.DeleteGame(slotNumber)
	UpdateSavesSelection()
	pass

func UpdateSavesSelection():
	for i in slots.size():
		if ResourceLoader.exists(SaveManager.SAVE_GAME_SLOT_PATHS[i]):
			slotLoadViews[i].visible = true
			slotNewGameViews[i].visible = false
		else:
			slotNewGameViews[i].visible = true
			slotLoadViews[i].visible = false
			
		pass
	pass

func _on_play_button_down():
	UpdateSavesSelection()
	saveSelect.visible = true
	Global.soundManager.PlayClick()
	
	pass # Replace with function body.


func _on_dev_mode_button_down():
	visible = false
	Global.soundManager.PlayClick()
	Global.gameManager.StartInDevMode("")
	pass # Replace with function body.


func _on_slot_load_button_down(extra_arg_0): 
	Global.soundManager.PlayClick()
	LoadSave(extra_arg_0)
	pass # Replace with function body.


func _on_slot_new_button_down(extra_arg_0):
	Global.soundManager.PlayClick()
	NewSave(extra_arg_0)
	pass # Replace with function body.


func _on_slot_delete_button_down(extra_arg_0):
	Global.soundManager.PlayClick()
	DeleteSave(extra_arg_0)
	pass # Replace with function body.


func _on_save_select_close_pressed() -> void:
	Global.soundManager.PlayClick()
	saveSelect.visible = false
	pass # Replace with function body.
