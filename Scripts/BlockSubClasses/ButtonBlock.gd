extends Block
@export var anim: AnimatedSprite2D
var neighbors: Array[Block]

func OnPlace():
	neighbors.clear()
	var _neighbors: Array[GridNode] = Global.worldManager.GetNeighbors(xGridPos,yGridPos)
	for neighbor in _neighbors:
		if neighbor != null && neighbor.block != null:
			neighbors.push_back(neighbor.block)
			neighbor.block.NeighborEntered(self)
	placed = true

func NeighborEntered(neighbor: Block): 
	neighbors.push_back(neighbor)
	#print("bruh")
	pass
	
func NeighborLeft(neighbor: Block):
	neighbors.erase(neighbor)
	pass

func PlayerInteract():
	anim.play("default")
	for neighbor in neighbors:
		neighbor.Activate()
	Global.soundManager.PlayClick()
	pass
