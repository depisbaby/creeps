extends Control
class_name Console

@onready var line: LineEdit = $LineEdit
@onready var debugText: RichTextLabel = $RichTextLabel

var packedScenes :Array[PackedScene]= [
	preload("res://BlockScenes/conveyor_down.tscn"),#0
	preload("res://BlockScenes/conveyor_left.tscn"),#1
	preload("res://BlockScenes/conveyor_multi.tscn"),#2
	preload("res://BlockScenes/conveyor_right.tscn"),#3
	preload("res://BlockScenes/conveyor_up.tscn"),#5
	preload("res://BlockScenes/ResourceProduction/miner_block.tscn"),#7
]
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.console = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_F1):
		visible = !visible
	pass


func _on_button_button_down():
	
	await get_tree().create_timer(0.1).timeout
	
	match line.text.substr(0,3):
		"plb":
			var packed = packedScenes[line.text.substr(3,1).to_int()]
			Global.gameManager.StartPlacingBlock(packed)
			pass
		
			pass
	
	pass # Replace with function body.
