extends Node
class_name SaveManager

var subscribers : Array
var loadedSave: SaveData


func _enter_tree():
	Global.saveManager = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func Subscribe(subscriber):
	if !subscriber.has_method("Load") || !subscriber.has_method("Save"):
		print_rich("[color=red]Subscriber '", subscriber.name, "' hasn't implemented load or save methods![/color]")
	
	subscribers.push_back(subscriber)
	
	pass
