extends Sprite2D
class_name Wire

var x:int
var y:int
var connections: Array[Wire]
var power: int 
var connectedBlock: Block

func _physics_process(delta):
	if power > 0:
		power = power - 1
	
	if power == 3 || power == 0:
		return
		
	for connection in connections:
		if connection.power == 0:
			connection.Activate()

func UpdateVisuals():
	var binary:String
	for connection in connections:
		if connection == null:
			binary = str("0",binary)
		else:
			binary = str("1",binary)
	#print(binary)
	#print(binary.bin_to_int())
	texture = Global.worldManager.wireSprites[binary.bin_to_int()]
	
	pass

func Connect(wire:Wire):
	var direction: Array[int] = [wire.x - x, wire.y - y]
	match direction:
		[0,-1]:
			connections[3] = wire
			return
		[1,0]:
			connections[2] = wire
			return
		[0,1]:
			connections[1] = wire
			return
		[-1,0]:
			connections[0] = wire
			return
	
func Activate():
	power = 3
	if connectedBlock != null:
		connectedBlock.Activate()
	pass
