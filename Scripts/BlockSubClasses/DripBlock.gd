extends ConveyorBlock
class_name DripBlock

var activated:bool

func _physics_process(delta):
	
	if !placed:
		return	
	
	if activated && Global.gameManager.tick % 60 == 0 && hasResources && connectedBlocks.size()!= 0:
		#print(Global.gameManager.tick)
		ReleaseResources()
		
		if resourcesHeld.size() == 0:
			hasResources = false
			
		activated = false
		
		pass

func Drip():
	activated = true
	pass

func PlayerInteract():
	#Drip()
	pass
	
func Activate():
	Drip()
	pass
