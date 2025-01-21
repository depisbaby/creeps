extends ConveyorBlock

var amountOfResources: int

func OnPlace():
	super.OnPlace()
	Global.buildMenu.UnlockBlock("Drip Block")
	Global.buildMenu.UnlockBlock("Constructor Block")
	pass
	
func ReceiveResource(_resource: _Resource, source:Block):
	
	lastSource = source
	amountOfResources = amountOfResources + 1
	if amountOfResources == 5:
		amountOfResources = 0
		Tinker()
	Global.resourceManager.ReturnToPool(_resource)
	

func Tinker():
	
	var random: int = randi_range(0,4)
	
	match random:
		0:
			CreateResource("Conveyor Kit")
			
			return
		1:
			CreateResource("Drill Bit")
			
			return
		2:
			CreateResource("Simple Motor")
			
			return
		3:
			CreateResource("Simple Components")
			
			return
		4:
			CreateResource("Simple Circuit")
			
			return
	pass
	
	
