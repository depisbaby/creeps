extends Control
class_name Cursor
@onready var icon:TextureRect = $TextureRect

func _enter_tree() -> void:
	Global.cursor = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
	pass
