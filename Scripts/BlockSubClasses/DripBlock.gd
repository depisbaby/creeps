extends ConveyorBlock
class_name DripBlock

func _physics_process(delta):
	
	pass

func Drip():
	if hasResources && connectedBlocks.size()!= 0:
		#print(Global.gameManager.tick)
		ReleaseResources()
		if resourcesHeld.size() == 0:
			hasResources = false
	pass

func PlayerInteract():
	Drip()
	pass
	
func Activate():
	Drip()
	pass
