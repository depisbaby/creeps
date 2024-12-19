extends Block
class_name ConveyorBlock

@export var directions: Array[int] #0 up, 1 right, 
var connected: Array[Block]
var lastSource: Block
var hasResources:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	connected.resize(4)
	pass # Replace with function body.

func _physics_process(delta):
	super._physics_process(delta)
	
	if !placed:
		return	
	
	if hasResources:
		ReleaseResources()
	
	pass
	
	
	if !placed:
		return	
	
	if hasResources:
		ReleaseResources()
	
	
func OnPlace():
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor.block != null:
			neighbor.block.NeighborEntered(self)
			if neighbor.block.resourceHolding:
				if directions.has(i):
					connected[i] = neighbor.block
					print("connected")
					i = i +1
					continue
		
		connected[i] = null
		i = i +1	
		
	placed = true
		

func NeighborEntered(_neighbor:Block):
	UpdateConnections()
	pass

func NeighborLeft(_neighbor:Block):
	UpdateConnections()
	
func UpdateConnections():
	var neighbors: Array[GridNode] = Global.gameManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor.block != null:
			if neighbor.block.resourceHolding:
				if directions.has(i):
					connected[i] = neighbor.block
					print("connected")
					i = i +1
					continue
		
		connected[i] = null
		i = i +1	
	pass

func ReceiveResources(resources:Array[int], source: Block):
	super.ReceiveResources(resources, source)
	lastSource = source
	hasResources = true
	
func ReleaseResources():
	while(true):
		var connection: Block = connected.pick_random()
		if connection != null && connection != lastSource:
			connection.ReceiveResources(resourceStorage.storage, self)
			hasResources = false
			resourceStorage.Clear()
			return
	
	
	
	
		
	
	
	
