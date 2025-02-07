extends Node2D
class_name SoundManager

@onready var footSteps:AudioStreamPlayer2D = $FootSteps
@onready var click:AudioStreamPlayer2D = $Click
@onready var explosion:AudioStreamPlayer2D = $Explosion
@onready var assemble:AudioStreamPlayer2D = $Assemble

func _enter_tree():
	Global.soundManager = self
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func PlayFootSteps():
	footSteps.pitch_scale = 1 + randf_range(-0.3, 0.3)
	footSteps.play()
	pass
	
func PlayClick():
	click.pitch_scale = 1 + randf_range(-0.1, 0.1)
	click.play()
	pass

func PlayExplosion():
	explosion.pitch_scale = 1 + randf_range(-0.1, 0.1)
	explosion.play()
	pass
	
func PlayAssemble():
	assemble.pitch_scale = 1 + randf_range(-0.1, 0.1)
	assemble.play()
	pass
