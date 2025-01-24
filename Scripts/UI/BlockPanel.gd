extends Control
class_name BlockPanel
@onready var icon : TextureRect = $TextureRect
@onready var new : Label = $new
var parent 
var block: Block

#tooltip
var hovering: bool
var hoveringTime: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	if hovering && hoveringTime < 60:
		hoveringTime = hoveringTime + 1
		
	if hovering && hoveringTime == 60:
		hoveringTime = hoveringTime + 1
		Global.tooltips.StartShowingBlockTooltip(block)
		


func _on_button_button_down():
	await get_tree().create_timer(0.1).timeout
	parent.SelectBlock(block)
	pass # Replace with function body.


func _on_button_mouse_entered():
	hovering = true
	pass # Replace with function body.


func _on_button_mouse_exited():
	hovering = false
	hoveringTime = 0
	Global.tooltips.StopShowingBlockTooltip()
	pass # Replace with function body.
