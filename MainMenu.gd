extends Control
class_name MainMenu

@onready var seed: LineEdit = $Seed

func _enter_tree():
	Global.mainMenu = self
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_button_down():
	visible = false
	Global.gameManager.StartNewGame(seed.text)
	pass # Replace with function body.
