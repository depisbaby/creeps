extends Block

@export var directionX: int
@export var directionY: int
var neighbors: Array[Block]
var subject: Block
var up:bool
	
func _physics_process(delta):
	if !placed:
		return
	if subject == null:
		return
	if (Global.gameManager.tick) % 60 == 0:
			
		if subject.resourcesHeld.size() > 0:
			print("resources detected")
			if up:
				return
			up = true
			Detect()
		else:
			print("no resources")
			if !up:
				return
			up = false
			Detect()
	

func OnPlace():
	UpdateConnections()
	super.OnPlace()
	pass

func UpdateConnections():
	
	subject = null
	var node = Global.worldManager.GetNodeAt(xGridPos+directionX,yGridPos+directionY)
	if node.block != null:
		subject = node.block
	
	neighbors.clear()
	var _neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	var i: int
	for neighbor in _neighbors:
		if neighbor!=null && neighbor.block != null:
			if neighbor.block == subject:
				continue
			neighbors.push_back(neighbor.block)
			print("connected")
		
		i = i +1	
	pass

func NeighborEntered(_neighbor:Block):
	UpdateConnections()
	pass

func NeighborLeft(_neighbor:Block):
	UpdateConnections()

func Detect():
	print(neighbors.size())
	for neighbor in neighbors:
		print("activate")
		neighbor.Activate()
	pass
