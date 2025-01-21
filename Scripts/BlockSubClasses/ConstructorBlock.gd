extends ConveyorBlock
class_name ConstructorBlock

var resourcesInputed: Array[String]
var resourcesOutputed: Array[String]
var recipes: Array[ConstructionRecipe]

func OnPlace():
	super.OnPlace()
	
	for recipe in Global.constructionManual.nonAbstractRecipes:
		if recipe.constructorBlock == blockName:
			recipes.push_back(recipe)
	

func ReceiveResource(_resource: _Resource, source:Block):
	lastSource = source
	
	resourcesInputed.push_back(_resource.resourceName)
	
	if resourcesInputed.size() == 5:
		doesntAcceptResources = true
	
	Global.resourceManager.ReturnToPool(_resource)


func Activate():
	if resourcesInputed.size() == 0:
		return
	
	var list :Array[ConstructionRecipe]
	for recipe in recipes: #filter
		if recipe.inputResources[0] == resourcesInputed[0]:
			list.push_back(recipe)
	if list.size() == 0:
		CreateResource("Mess")
		resourcesInputed.clear()
		doesntAcceptResources = false
		return
	
	for recipe in list:
		
		if recipe.inputResources.size()!= resourcesInputed.size():
			continue
			
		var i:int
		var matching: bool = true
		for input in recipe.inputResources:
			if input != resourcesInputed[i]:
				matching = false
				break
			i=i+1
		
		if matching:
			for output in recipe.outputResources:
				CreateResource(output)
				resourcesInputed.clear()
				doesntAcceptResources = false
				return
			
	CreateResource("Mess")
	resourcesInputed.clear()
	doesntAcceptResources = false
			
	
		
		
