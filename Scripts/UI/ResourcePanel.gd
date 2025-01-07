extends Control
class_name ResourcePanel

var resourceName: String
@onready var sprite: TextureRect = $TextureRect
@onready var amountLabel: Label = $Label
var parent




func _on_button_button_down():
	if parent != null:
		parent.ResourcePanelClicked(resourceName)
	pass # Replace with function body.
