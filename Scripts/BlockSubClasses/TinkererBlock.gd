extends ConveyorBlock

var amountOfResources: int

func OnPlace():
	super.OnPlace()
	Global.buildMenu.UnlockBlock("Drip Block")
	Global.buildMenu.UnlockBlock("Simple Constructor Block")
	Global.buildMenu.UnlockBlock("Button Block")
	pass
	
func ReceiveResource(_resource: _Resource, source:Block):
	inputBlocks.push_back(source)
	Global.resourceManager.ReturnToPool(_resource)
	
	amountOfResources = amountOfResources + 1
	
	if amountOfResources == 5:
		amountOfResources = 0
		Tinker()
	

func Tinker():
	
	var random: int = randi_range(0,3)
	animatedSprite.play("tinker")
	match random:
		0:
			CreateResource("Conveyor Kit")
			
			return
		1:
			CreateResource("Simple Motor")
			
			return
		2:
			CreateResource("Simple Components")
			
			return
		3:
			CreateResource("Simple Circuit")
			
			return
	pass
	
	
