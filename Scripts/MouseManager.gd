extends CharacterBody2D
class_name MouseManager

func _enter_tree():
	Global.mouseManager = self
	pass

func GetMousePosition() -> Vector2:
	return get_global_mouse_position()
