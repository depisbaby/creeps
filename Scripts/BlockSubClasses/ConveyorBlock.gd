extends Block
class_name ConveyorBlock

@export var directions: Array[int] #0 up, 1 right, 
@export var animatedSprite: AnimatedSprite2D
var connectedBlocks: Array[Block]
var inputBlocks: Array[Block]
var nextConnection: int
var hasResources:bool


func _physics_process(delta):
	
	if !placed:
		return	
	
	if Global.gameManager.tick % 60 == 0 && hasResources && connectedBlocks.size()!= 0:
		#print(Global.gameManager.tick)
		ReleaseResources()
		if resourcesHeld.size() == 0:
			hasResources = false
	
	
	pass
	
	
	
	
func OnPlace():
	connectedBlocks.clear()
	inputBlocks.clear()
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor!=null&& neighbor.block != null:
			neighbor.block.NeighborEntered(self)
			if neighbor.block.canHoldResources:
				if directions.has(i):
					connectedBlocks.push_back(neighbor.block)
					#print("connected")
					i = i +1
					continue
		
		i = i +1	
		
	placed = true
	
	

func NeighborEntered(_neighbor:Block):
	UpdateConnections()
	pass

func NeighborLeft(_neighbor:Block):
	UpdateConnections()
	
func UpdateConnections():
	connectedBlocks.clear()
	inputBlocks.clear()
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor!=null && neighbor.block != null:
			if neighbor.block.canHoldResources:
				if directions.has(i):
					connectedBlocks.push_back(neighbor.block)
					#print("connected")
					i = i +1
					continue
		
		i = i +1	
	pass
	
	
func ReceiveResource(resource:_Resource, source: Block):
	resource.ChangeHolder(self)
	resourcesHeld.push_back(resource)
	
	if !inputBlocks.has(source) && source != self:
		inputBlocks.push_back(source)
	
	hasResources = true
	
	if resourcesHeld.size() >= 5:
		doesntAcceptResources = true

func CreateResource(resourceName :String):
	
	var resource = Global.resourceManager.PopFromPoolWithName(resourceName)
	resource.global_position = global_position
	
	resource.ChangeHolder(self)
	resourcesHeld.push_back(resource)
	
	hasResources = true

func ReleaseResources():
	
	if resourcesHeld[0].movingCooldown != 0:
		return
	
	#one directional
	if connectedBlocks.size() == 1:
		if !connectedBlocks[0].doesntAcceptResources:
			connectedBlocks[0].ReceiveResource(resourcesHeld.pop_front(),self)
			doesntAcceptResources = false
		return
	
	#multi directional
	var i=0
	while(i<connectedBlocks.size()):
		
		if nextConnection > connectedBlocks.size()-1: #wrap
			nextConnection = 0
		
		var nextReceiver:Block = connectedBlocks[nextConnection]
		
		if inputBlocks.has(nextReceiver):
			nextConnection = nextConnection + 1
			i = i + 1
			continue
		if nextReceiver.doesntAcceptResources:
			nextConnection = nextConnection + 1
			i = i + 1
			continue
		
		nextReceiver.ReceiveResource(resourcesHeld.pop_front(),self)
		nextConnection = nextConnection + 1
		doesntAcceptResources = false
		break
	
	
	
	
	
		
	
	
	
