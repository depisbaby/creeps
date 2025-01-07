extends Node
class_name SaveManager

var subscribers : Array
var loadedSave: SaveData

const SAVE_GAME_SLOT_PATHS:Array[String] =["user://save_slot1.tres","user://save_slot2.tres","user://save_slot3.tres"]


func _enter_tree():
	Global.saveManager = self
	
	Subscribe($"../WorldManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func StartNewGame(seed:String, slot: int):
	#create default values
	loadedSave = SaveData.new()
	loadedSave.slotNumber = slot
	loadedSave.seed = seed
	
	#load stuff
	for subscriber in subscribers:
		subscriber.Load(loadedSave)
	
	pass

func LoadGame(slot:int):
	loadedSave = ResourceLoader.load(SAVE_GAME_SLOT_PATHS[slot])
	for subscriber in subscribers:
		subscriber.Load(loadedSave)
	pass

func DeleteGame(slot:int):
	var file_path = SAVE_GAME_SLOT_PATHS[slot]
	if FileAccess.file_exists(file_path):
		var dir = DirAccess.open(file_path.get_base_dir())
		if dir:
			var err = dir.remove(file_path)
			if err == OK:
				return true
			else:
				print("Failed to delete file. Error code: ", err)
				return false
	else:
		print("File does not exist at path: ", file_path)
		return false
	pass
	
func SaveGame():
	for subscriber in subscribers:
		subscriber.Save(loadedSave)
	ResourceSaver.save(loadedSave,SAVE_GAME_SLOT_PATHS[loadedSave.slotNumber])
	pass
	
	
func Subscribe(subscriber):
	if !subscriber.has_method("Load") || !subscriber.has_method("Save"):
		print_rich("[color=red]Subscriber '", subscriber.name, "' hasn't implemented load or save methods![/color]")
	
	subscribers.push_back(subscriber)
	
	pass
