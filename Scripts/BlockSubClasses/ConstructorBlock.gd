extends ConveyorBlock
class_name ConstructorBlock

var resourcesInputed: Array[String]
var recipes: Array[ConstructionRecipe]

func OnPlace():
	super.OnPlace()
	
	for recipe in Global.constructionManual.nonAbstractRecipes:
		if recipe.constructorBlock == blockName:
			recipes.push_back(recipe)
	

func ReceiveResource(_resource: _Resource, source:Block):
	
	Global.resourceManager.ReturnToPool(_resource)
	
	if !inputBlocks.has(source) && source != self:
		inputBlocks.push_back(source)
	
	resourcesInputed.push_back(_resource.resourceName)
	
	if resourcesInputed.size() >= 5:
		doesntAcceptResources = true
	


func Activate():
	animatedSprite.play("default")
	if resourcesInputed.size() == 0:
		return
	
	if resourcesInputed.has("Mess"):
		Global.worldManager.CreateExplosion(xGridPos,yGridPos, 12, 4)
		return
	
	var list :Array[ConstructionRecipe]
	for recipe in recipes: #filter
		if recipe.inputResources[0] == resourcesInputed[0]:
			list.push_back(recipe)
	if list.size() == 0:
		doesntAcceptResources = false
		CreateResource("Mess")
		resourcesInputed.clear()
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
				doesntAcceptResources = false
				CreateResource(output)
				resourcesInputed.clear()
				return
				
	doesntAcceptResources = false
	CreateResource("Mess")
	resourcesInputed.clear()
			
	
		
		
