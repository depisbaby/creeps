extends Block
class_name ConductionBlock

@export var outputDirections :Array[int]
@export var isWireTerminal: bool

var connectedBlocks: Array[Block]
var connectedConductors: Array[ConductionBlock]
var conducted: bool
var connectedWire: Wire
var activateCooldown: int

func _physics_process(delta):
	conducted = false
	
	if activateCooldown > 0:
		activateCooldown = activateCooldown - 1
	

func Activate():
	if activateCooldown != 0:
		return
	activateCooldown = 5
	Conduct(5)
	pass


func Conduct(strength: int):
	if conducted:
		return
	if strength == 0:
		return
	
	conducted = true
	
	if connectedWire != null:
		#print("hep")
		connectedWire.Activate()
	
	#Global.effectManager.DisplayStatusIcon(global_position + Vector2(randi_range(-3,3),randi_range(-3,3)),strength)
	
	for conductor in connectedConductors:
		conductor.Conduct(strength - 1)
	
	for connectedBlock in connectedBlocks:
		connectedBlock.Activate()

	pass
	
	
func OnPlace():
	connectedBlocks.clear()
	connectedConductors.clear()
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor!=null&& neighbor.block != null:
			neighbor.block.NeighborEntered(self)
			if outputDirections.has(i):
				if neighbor.block is ConductionBlock:
					connectedConductors.push_back(neighbor.block)
				else:
					connectedBlocks.push_back(neighbor.block)
				
				
				
				i = i +1
				continue
		
		i = i +1	
		
	placed = true
	
	if isWireTerminal:
		var node = Global.worldManager.GetNodeAt(xGridPos,yGridPos)
		if node.wire != null:
			connectedWire = node.wire
			
	pass
	
func NeighborEntered(_neighbor:Block):
	UpdateConnections()
	pass

func NeighborLeft(_neighbor:Block):
	UpdateConnections()
	
func UpdateConnections():
	connectedBlocks.clear()
	connectedConductors.clear()
	var neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in neighbors:
		if neighbor!=null && neighbor.block != null:
			if outputDirections.has(i):
				if neighbor.block is ConductionBlock:
					connectedConductors.push_back(neighbor.block)
				else:
					connectedBlocks.push_back(neighbor.block)
				
				i = i +1
				continue
		
		i = i +1	
	pass
