extends Sprite2D
class_name Wire

var x:int
var y:int
var connections: Array[Wire]
var power: int 
var connectedBlock: ConductionBlock
var activatedThisFrame: bool

func _physics_process(delta):
	if activatedThisFrame:
		activatedThisFrame = false
		return
	
	if power == 10:
		for connection in connections:
			if connection!= null && connection.power == 0:
				connection.Activate()
		
	if power > 0:
		power = power - 1
	
func UpdateVisuals():
	#print("updating")
	var binary: String
	var j:int = 3
	for i in 4:
		if connections[j] == null:
			binary = str("0",binary)
		else:
			binary = str("1",binary)
		j = j-1
		
	#print(binary)
	#print(binary.bin_to_int())
	#binary.reverse()
	texture = Global.worldManager.wireSprites[binary.bin_to_int()]
	
	pass

func Connect(wire:Wire):
	var direction: Array[int] = [wire.x - x, wire.y - y]
	match direction:
		[0,-1]:
			connections[0] = wire
			return
		[1,0]:
			connections[1] = wire
			return
		[0,1]:
			connections[2] = wire
			return
		[-1,0]:
			connections[3] = wire
			return

func Disconnect(wire:Wire):
	var i :int
	for connection in connections:
		if wire == connection:
			connections[i] = null
			#print("hep")
		i = i + 1

func Activate():
	power = 10
	activatedThisFrame = true
	#Global.effectManager.DisplayStatusIcon(global_position, 0)
	if connectedBlock != null:
		connectedBlock.Activate()
	pass

func GetConnectionStatus()->Array[bool]:
	var result: Array[bool] = [false,false,false,false]
	var i:int
	for connection in connections:
		if connection != null:
			result[i]= true
		i= i+1
	return result
