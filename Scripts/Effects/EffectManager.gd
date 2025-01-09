extends Node2D
class_name EffectManager

@export var statusIconPackedScene : PackedScene
var statusIconPool: Array[StatusIcon]
var statusIcons: Array[Texture2D] = [
	#blocklevels
	preload("res://Sprites/Icons/blocklevels/1.png"),#0
	preload("res://Sprites/Icons/blocklevels/2.png"),#1
	preload("res://Sprites/Icons/blocklevels/3.png"),#2
	preload("res://Sprites/Icons/blocklevels/4.png"),#3
	preload("res://Sprites/Icons/blocklevels/5.png"),#4
	preload("res://Sprites/Icons/blocklevels/6.png"),#5
	preload("res://Sprites/Icons/blocklevels/7.png"),#6
	preload("res://Sprites/Icons/blocklevels/8.png"),#7
	preload("res://Sprites/Icons/blocklevels/9.png"),#8
	preload("res://Sprites/Icons/blocklevels/10.png"),#9
	preload("res://Sprites/Icons/collected.png"),#10
	preload("res://Sprites/Icons/missing_resources.png")#11
	
]

func _enter_tree():
	Global.effectManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	ScaleUpStatusIconPool(100)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func DisplayStatusIcon(position: Vector2, statusIconId: int):
	
	var icon = statusIconPool.pop_front()
	if icon == null:
		ScaleUpStatusIconPool(100)
		DisplayStatusIcon(position, statusIconId)
	icon.texture = statusIcons[statusIconId]
	icon.global_position = position
	icon.Play()
	pass

func ScaleUpStatusIconPool(amount: int):
	
	for i in amount:
		var instance = statusIconPackedScene.instantiate()
		add_child(instance)
		instance.visible = false
		statusIconPool.push_back(instance)
	
	pass
