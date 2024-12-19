extends Control
class_name Console

@onready var line: LineEdit = $LineEdit
@onready var debugText: RichTextLabel = $RichTextLabel

var packedScenes :Array[PackedScene]= [
	preload("res://BlockScenes/conveyor_down.tscn"),#0
	preload("res://BlockScenes/conveyor_left.tscn"),#1
	preload("res://BlockScenes/conveyor_multi.tscn"),#2
	preload("res://BlockScenes/conveyor_right.tscn"),#3
	preload("res://BlockScenes/conveyor_monitor.tscn"),#4
	preload("res://BlockScenes/conveyor_up.tscn"),#5
	preload("res://BlockScenes/conveyor_spawner.tscn")#6
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
	
	match line.text:
		"conveyor_multi":
			var instance = packedScenes[2].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_up":
			var instance = packedScenes[5].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_down":
			var instance = packedScenes[0].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_right":
			var instance = packedScenes[3].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_left":
			var instance = packedScenes[1].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_monitor":
			var instance = packedScenes[4].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
		"conveyor_spawner":
			var instance = packedScenes[6].instantiate()
			Global.gameManager.StartPlacingBlock(instance,0,1)
			pass
	
	pass # Replace with function body.
