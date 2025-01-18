extends Control
class_name BuildMenu

@onready var gridStart: Control = $gridstart
var panelGrid: Array[BlockPanel]
@onready var blockPanelPacked : PackedScene = preload("res://UIScenes/block_panel.tscn")

var availableBlocks: Array[Block]

var blockLibrary: Array[PackedScene] = [
	preload("res://BlockScenes/conveyor_up.tscn"),
	preload("res://BlockScenes/conveyor_right.tscn"),
	preload("res://BlockScenes/conveyor_down.tscn"),
	preload("res://BlockScenes/conveyor_left.tscn"),
	preload("res://BlockScenes/conveyor_multi.tscn"),
	preload("res://BlockScenes/Turrets/twin_fire.tscn"),
	preload("res://BlockScenes/ResourceProduction/miner_block.tscn"),
	preload("res://BlockScenes/chest_block.tscn"),
	preload("res://BlockScenes/NonDynamic/rock_block.tscn"),
	preload("res://BlockScenes/ResourceProduction/tinkerer_block.tscn"),
	preload("res://BlockScenes/Conveyors/splitter_down.tscn"),
	preload("res://BlockScenes/Conveyors/splitter_left.tscn"),
	preload("res://BlockScenes/Conveyors/splitter_right.tscn"),
	preload("res://BlockScenes/Conveyors/splitter_up.tscn"),
	preload("res://BlockScenes/NonDynamic/bedrock_block.tscn"),
	preload("res://BlockScenes/Conveyors/drip_block.tscn"),
	preload("res://BlockScenes/Wiring/button_block.tscn"),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	#preload(),
	
]
var blockLibraryInstances: Array[Block]


func _enter_tree():
	Global.buildMenu = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	for packed in blockLibrary:
		var instance = packed.instantiate()
		blockLibraryInstances.push_back(instance)
		pass
	
	InitializeGrid()
	OpenPage(0,"")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func OpenView():
	visible = true
	
func InitializeGrid():
	
	for y in 9:
		for x in 13:
			var instance: BlockPanel = blockPanelPacked.instantiate()
			add_child(instance)
			instance.position = gridStart.position + Vector2(x*100, y* 100)
			instance.parent = self
			panelGrid.push_back(instance)
			
	
	pass
	
func OpenPage(pageNumb:int, tag:String):
	
	for panel in panelGrid:
		panel.visible = false
	
	var blockLibraryHead :int = 0
	var panelGridHead: int = 0
	var pageFirstIndex : int = pageNumb * 117
	var pageLastIndex : int = pageNumb * 117 + 116
	
	for block in availableBlocks:
		if block._tags.has(tag) || tag == "":
			if blockLibraryHead >= pageFirstIndex && blockLibraryHead <= pageLastIndex:
				var panel:BlockPanel = panelGrid[panelGridHead]
				panel.icon.texture = block.menuIcon
				panel.visible = true
				panel.block = block
				
				panelGridHead = panelGridHead + 1
				blockLibraryHead = blockLibraryHead + 1
		
	pass

func SelectBlock(block: Block):
	Global.worldManager.StartPlacingBlock(block)
	pass

func GetBlockReferenceByName(name:String)->Block:
	for block in blockLibraryInstances:
		if block.blockName == name:
			return block
			
	return null
	pass
	
func UnlockBlock(blockName:String):
	for block in availableBlocks:
		if block.blockName == blockName:
			return
			
	for block in blockLibraryInstances:
		if block.blockName == blockName:
			availableBlocks.push_back(block)
	
	OpenPage(0,"")

func EnterInDevMode():
	for block in blockLibraryInstances:
		availableBlocks.push_back(block)
		
	OpenPage(0,"")
	pass

func _on_close_button_down():
	visible = false
	pass # Replace with function body.

func _on_wiring_button_down():
	await get_tree().create_timer(0.1).timeout
	Global.worldManager.StartWiring() 
	pass # Replace with function body.
