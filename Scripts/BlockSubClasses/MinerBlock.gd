extends ConveyorBlock
class_name MinerBlock

@export var resourceIcon: Sprite2D

var produceName: String
var spriteId:int


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !placed:
		return	
	#print(Global.gameManager.tick)
	#print(connectedBlocks.size())
	#print("wave: ",Global.gameManager.waveInProgress)
	if Global.gameManager.tick % (60*5) == 0 && connectedBlocks.size()!= 0:
		CreateResource(produceName)

func OnPlace():
	super.OnPlace()
	var node = Global.worldManager.GetNodeAt(xGridPos,yGridPos)
	var value = node.miningValue
	
	
	if value < -0.30:
		#debug.modulate = Color.WHITE
		SetProducedResource("Oil", 2)
	elif value < -0.20:
		#debug.modulate = Color.RED
		SetProducedResource("Element-VK", 0)
	elif value < -0.10:
		#debug.modulate = Color.DARK_BLUE
		SetProducedResource("Pseudo Iron", 3)
	elif value < 0.00:
		#debug.modulate = Color.YELLOW
		SetProducedResource("Purplutide", 4)
	elif value < 0.10:
		#debug.modulate = Color.CORAL
		SetProducedResource("Smooth Stuff", 5)
	elif value < 0.20:
		#debug.modulate = Color.PURPLE
		SetProducedResource("Mean Looking Crystals", 1)
	elif value < 0.30:
		#debug.modulate = Color.PURPLE
		SetProducedResource("Volcanite", 6)
	else:
		#debug.modulate = Color.GREEN
		SetProducedResource("Wonksten", 7)
	
	
func SetProducedResource(name:String, _spriteId):
	produceName = name
	spriteId = _spriteId
	var resource = Global.resourceManager.GetResourceByName(name)
	resourceIcon.texture = resource.texture
	
	pass
