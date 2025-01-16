extends ConveyorBlock

var amountOfResources: int

func _init():
	Global.constructionManual.CreateRecipe(["Any resource","Any resource","Any resource","Any resource","Any resource"],["Drill Bit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(["Any resource","Any resource","Any resource","Any resource","Any resource"],["Conveyor Kit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Circuit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Components"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Motor"],"Tinkerer Block")
	Global.buildMenu.UnlockBlock("Splitter Block (up)")
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	
