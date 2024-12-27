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
	if Global.gameManager.tick % 60 == 0 && connectedBlocks.size()!= 0 && Global.resourceManager.waveInProgress:
		ProduceResource()

func OnPlace():
	super.OnPlace()
	var node = Global.gameManager.GetNodeAt(xGridPos,yGridPos)
	var miningValue = node.miningValue
	
	print(miningValue)
	
	if miningValue < -0.15:
		SetProducedResource("oil", 2)
		return
	if miningValue < 0.15:
		SetProducedResource("brass", 0)
		return
	else:
		SetProducedResource("gun_powder", 1)
		return
	

func ProduceResource():
	#print("hep")
	var resource = Global.resourceManager.PopFromPool(produceName,spriteId)
	resource.global_position = global_position
	ReceiveResource(resource,self)
	
	pass
	
func SetProducedResource(name:String, _spriteId):
	produceName = name
	spriteId = _spriteId
	
	resourceIcon.texture = Global.resourceManager.sprites[spriteId]
	
	pass
