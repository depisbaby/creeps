extends Node
class_name SaveManager

var subscribers : Array
var loadedCharacterData: CharacterSaveData
var loadedWorldData: WorldSaveData


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
	loadedCharacterData = CharacterSaveData.new()
	loadedCharacterData.slotNumber = slot
	
	loadedWorldData = WorldSaveData.new()
	loadedWorldData.slotNumber = slot
	loadedWorldData.seed = seed
	
	loadedCharacterData.currentWorldPath = str("user://slot",slot,"_world",1,".tres")
	loadedCharacterData.worldPaths.push_back(loadedCharacterData.currentWorldPath)
	
	#load stuff
	for subscriber in subscribers:
		await subscriber.Load()
	
	pass

func LoadGame(slot:int, worldPath: String):
	loadedCharacterData = ResourceLoader.load(SAVE_GAME_SLOT_PATHS[slot])
	if worldPath == "":
		loadedWorldData = ResourceLoader.load(loadedCharacterData.currentWorldPath)
	else:
		loadedWorldData = ResourceLoader.load(worldPath)
	
	for subscriber in subscribers:
		await subscriber.Load()
		
	LoadBlockInventories()
	pass

func DeleteGame(slot:int):
	var data: CharacterSaveData = ResourceLoader.load(SAVE_GAME_SLOT_PATHS[slot])
	for world in data.worldPaths:
		DeleteWorld(world)
	DeleteSave(slot)
	pass

func DeleteSave(slot:int):
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
	
func DeleteWorld(path: String):
	var file_path = path
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
	if Global.gameManager.devMode:
		return
	
	loadedWorldData.blockInventories.clear()
	
	for subscriber in subscribers:
		await subscriber.Save()
	
	ResourceSaver.save(loadedWorldData,loadedCharacterData.currentWorldPath)
	ResourceSaver.save(loadedCharacterData,SAVE_GAME_SLOT_PATHS[loadedCharacterData.slotNumber])
	
	pass
	
	
func Subscribe(subscriber):
	if !subscriber.has_method("Load") || !subscriber.has_method("Save"):
		print_rich("[color=red]Subscriber '", subscriber.name, "' hasn't implemented load or save methods![/color]")
	
	subscribers.push_back(subscriber)
	
	pass

#===============SAVE HELPERS =========================
#=====================================================
#Block inventories
func LoadBlockInventories():
	for blockInventory in loadedWorldData.blockInventories:
		var inv = blockInventory as BlockInventory
		var x = inv.xPosition 
		var y = inv.yPosition
		var node = Global.worldManager.GetNodeAt(x,y)
		node.block.blockInventory = blockInventory
		#print("sdgsdgsdg")
		pass
