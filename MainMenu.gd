extends Control
class_name MainMenu

@onready var saveSelect: Control =$SaveSelect
@onready var seed: LineEdit = $Seed

#slots
@onready var slots: Array[Control] = [$SaveSelect/Slot1,]
@onready var slotNameLabels: Array[Label] = [$SaveSelect/Slot1/slot_name,]
@onready var slotLoadViews:Array[Control] = [$SaveSelect/Slot1/LoadView]
@onready var slotNewGameView:Array[Control] = [$SaveSelect/Slot1/NewGameView]


func _enter_tree():
	Global.mainMenu = self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	saveSelect.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_down():
	saveSelect.visible = true
	
	pass # Replace with function body.


func _on_dev_mode_button_down():
	visible = false
	Global.gameManager.StartInDevMode("")
	pass # Replace with function body.
