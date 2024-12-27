extends Block
class_name ConveyorBlock

@export var directions: Array[int] #0 up, 1 right, 
var connectedBlocks: Array[Block]
var lastSource: Block
var nextConnection: int
var hasResources:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.

func _physics_process(delta):
	super._physics_process(delta)
	
	if !placed:
		return	
	
	if Global.gameManager.tick % 20 == 0 && hasResources && connectedBlocks.size()!= 0:
		#print(Global.gameManager.tick)
		ReleaseResources()
		if resourcesHeld.size() == 0:
			hasResources = false
	
	
	pass
	
	
	
	
func OnPlace():
	connectedBlocks.clear()
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor.block != null:
			neighbor.block.NeighborEntered(self)
			if neighbor.block.canHoldResources:
				if directions.has(i):
					connectedBlocks.push_back(neighbor.block)
					print("connected")
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
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor.block != null:
			if neighbor.block.canHoldResources:
				if directions.has(i):
					connectedBlocks.push_back(neighbor.block)
					print("connected")
					i = i +1
					continue
		
		i = i +1	
	pass
	
func WaveStarted():
	super.WaveStarted()
	nextConnection = 0
	pass
	
func WaveCompleted():
	super.WaveCompleted()
	hasResources = false
	
func ReceiveResource(resource:_Resource, source: Block):
	super.ReceiveResource(resource, source)
	lastSource = source
	hasResources = true
	
func ReleaseResources():
	
	if resourcesHeld[0].movingCooldown != 0:
		return
	
	#one directional
	if connectedBlocks.size() == 1:
		connectedBlocks[0].ReceiveResource(resourcesHeld.pop_front(),self)
		
		return
	
	#multi directional
	if nextConnection > connectedBlocks.size()-1:
			nextConnection = 0
	
	var nextReceiver:Block = connectedBlocks[nextConnection]
	if nextReceiver == lastSource:
		nextConnection = nextConnection + 1
		
		if nextConnection > connectedBlocks.size()-1:
			nextConnection = 0
		
		nextReceiver = connectedBlocks[nextConnection]
		
	nextReceiver.ReceiveResource(resourcesHeld.pop_front(),self)
	nextConnection = nextConnection + 1
	
	
	
	
	
		
	
	
	
