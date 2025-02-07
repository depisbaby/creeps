extends ConveyorBlock
class_name MinerBlock

@export var resourceIcon: Sprite2D

var produceName: String
var spriteId:int
var fuel:int
@onready var fillSprite:Sprite2D = $fill
var filledHeight: int = -3
var trash: int

func _ready():
	super._ready()
	

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if !placed:
		return	
	#print(Global.gameManager.tick)
	#print(connectedBlocks.size())
	#print("wave: ",Global.gameManager.waveInProgress)
	if resourcesHeld.size() >= 5:
		return
	
	if Global.gameManager.tick % (60*5) == 0 && connectedBlocks.size()!= 0 && fuel > 0:
		fuel = fuel - 1
		fillSprite.position = Vector2(fillSprite.position.x, fillSprite.position.y + 1)
		CreateResource(produceName)

func OnPlace():
	super.OnPlace()
	var node = Global.worldManager.GetNodeAt(xGridPos,yGridPos)
	var value = node.miningValue
	
	if value == 3.0:
		fuel = 11
		fillSprite.position = Vector2(fillSprite.position.x, -3)
		SetProducedResource("Oil", 2)
		return
	
	if value < -0.40:
		#debug.modulate = Color.WHITE
		SetProducedResource("Rock", 2)
	
	elif value < -0.20:
		#debug.modulate = Color.RED
		SetProducedResource("Element-VK", 0)
	elif value < -0.10:
		#debug.modulate = Color.DARK_BLUE
		SetProducedResource("Pseudo Iron", 3)
	elif value < 0.00:
		#debug.modulate = Color.GREEN
		SetProducedResource("Wonksten", 7)
	elif value < 0.10:
		#debug.modulate = Color.PURPLE
		SetProducedResource("Volcanite", 6)
		
	elif value < 0.20:
		#debug.modulate = Color.PURPLE
		SetProducedResource("Mean Looking Crystals", 1)
	elif value < 0.30:
		#debug.modulate = Color.CORAL
		SetProducedResource("Smooth Stuff", 5)
	else:
		#debug.modulate = Color.YELLOW
		SetProducedResource("Purplutide", 4)
		
	
	
	
func SetProducedResource(name:String, _spriteId):
	produceName = name
	spriteId = _spriteId
	var resource = Global.resourceManager.GetResourceByName(name)
	resourceIcon.texture = resource.texture
	
	pass
	
func ReceiveResource(_resource:_Resource, source: Block):
	
	if !inputBlocks.has(source) && source != self:
		inputBlocks.push_back(source)
	
	Global.resourceManager.ReturnToPool(_resource)
	
	if _resource.resourceName == "Oil":
		fuel = 11
		fillSprite.position = Vector2(fillSprite.position.x, -3)
		return
		
	trash = trash + 1
	if trash < 5:
		return
	
	Global.worldManager.CreateExplosion(xGridPos,yGridPos, 12, 4)
	
	pass
