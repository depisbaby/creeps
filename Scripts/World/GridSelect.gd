extends Sprite2D
class_name GridSelect

@onready var label:Label = $Label

var sprites : Array[Texture2D] = [
	preload("res://Sprites/Icons/grid_select.png"),
	preload("res://Sprites/Icons/block_lift.png"),
	preload("res://Sprites/Icons/block_drop.png"),
	preload("res://Sprites/Icons/block_demolish.png")
]

func _enter_tree():
	Global.gridSelect = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
