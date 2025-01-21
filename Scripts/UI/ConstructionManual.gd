extends Control
class_name ConstructionManual

@onready var resourcePanel: PackedScene = preload("res://UIScenes/resource_panel.tscn")
@onready var gridStart: Control = $gridStart
var grid : Array[ResourcePanel]

#recipe window
@onready var recipeWindow:Control = $RecipeWindow
var recipes: Array[ConstructionRecipe] = [
	preload("res://Resources/ConstructionRecipes/blank_recipe.tres"),
]
var nonAbstractRecipes:Array[ConstructionRecipe] = [
	
]

var relevantRecipes: Array[ConstructionRecipe]
@onready var inputIcons: Array[TextureRect] = [
	$RecipeWindow/input_base/input_box1/input_resource1,
	$RecipeWindow/input_base/input_box2/input_resource2,
	$RecipeWindow/input_base/input_box3/input_resource3,
	$RecipeWindow/input_base/input_box4/input_resource4,
	$RecipeWindow/input_base/input_box5/input_resource5,
]
@onready var outputIcons: Array[TextureRect] = [
	$RecipeWindow/output_base/output_box1/output_resource1,
	$RecipeWindow/output_base/output_box2/output_resource2,
	$RecipeWindow/output_base/output_box3/output_resource3,
	$RecipeWindow/output_base/output_box4/output_resource4,
	$RecipeWindow/output_base/output_box5/output_resource5,
]
@onready var inputBoxes:Array[TextureRect] = [
	$RecipeWindow/input_base/input_box1,
	$RecipeWindow/input_base/input_box2,
	$RecipeWindow/input_base/input_box3,
	$RecipeWindow/input_base/input_box4,
	$RecipeWindow/input_base/input_box5
]

@onready var outputBoxes:Array[TextureRect] = [
	$RecipeWindow/output_base/output_box1,
	$RecipeWindow/output_base/output_box2,
	$RecipeWindow/output_base/output_box3,
	$RecipeWindow/output_base/output_box4,
	$RecipeWindow/output_base/output_box5
]
@onready var inputArrows:Array[TextureRect]=[
	$RecipeWindow/input_base/input_arrow1,
	$RecipeWindow/input_base/input_arrow2,
	$RecipeWindow/input_base/input_arrow3,
	$RecipeWindow/input_base/input_arrow4,
	$RecipeWindow/input_base/input_arrow5
]

@onready var outputArrows:Array[TextureRect]=[
	$RecipeWindow/output_base/output_arrow1,
	$RecipeWindow/output_base/output_arrow2,
	$RecipeWindow/output_base/output_arrow3,
	$RecipeWindow/output_base/output_arrow4,
	$RecipeWindow/output_base/output_arrow5
]
@onready var inputLabels:Array[Label]=[
	$RecipeWindow/input_base/input_Label1,
	$RecipeWindow/input_base/input_Label2,
	$RecipeWindow/input_base/input_Label3,
	$RecipeWindow/input_base/input_Label4,
	$RecipeWindow/input_base/input_Label5
]
@onready var outputLabels:Array[Label]=[
	$RecipeWindow/output_base/output_Label1,
	$RecipeWindow/output_base/output_Label2,
	$RecipeWindow/output_base/output_Label3,
	$RecipeWindow/output_base/output_Label4,
	$RecipeWindow/output_base/output_Label5
]

@onready var blockIcon: TextureRect = $RecipeWindow/block_icon
@onready var recipeNameLabel: Label = $RecipeWindow/recipeName
@onready var inputBase: Control = $RecipeWindow/input_base
@onready var outputBase: Control = $RecipeWindow/output_base
var basesDefaultHeight: float
var recipeHead: int

func _enter_tree():
	Global.constructionManual = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	basesDefaultHeight = inputBase.position.y
	await InitializeGrid()
	InitializeResources()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func OpenView():
	visible = true
	pass	
	
func InitializeGrid():
	await get_tree().create_timer(0.1).timeout
	var i: int
	for y in 19:
		for x in 24:
			var instance: ResourcePanel = resourcePanel.instantiate()
			gridStart.add_child(instance)
			instance.global_position = gridStart.global_position + Vector2(x*42, y*42)
			instance.visible = false
			instance.parent = self
			grid.push_back(instance)
	gridStart.visible = false
	gridStart.visible = true

func InitializeResources():
	
	while (Global.resourceManager.resourceLibrary.size() == 0):
		await get_tree().create_timer(0.01).timeout
	
	var i: int= 0
	for resource in Global.resourceManager.resourceLibrary:
		grid[i].sprite.texture = resource.texture
		grid[i].resourceName = resource.resourceName
		grid[i].visible = true
		i=i+1
		pass

func _on_close_button_down():
	visible = false
	pass # Replace with function body.
	
func ResourcePanelClicked(resourceName:String):
	
	OpenRecipesWithOutput(resourceName)
	pass
	
func CreateRecipe(abstract:bool,inputResources:Array[String], outputResources:Array[String], constructorBlock:String):

	var recipe = ConstructionRecipe.new()
	recipe.inputResources = inputResources
	recipe.outputResources = outputResources
	recipe.constructorBlock = constructorBlock
	recipes.push_back(recipe)
	if !abstract:
		nonAbstractRecipes.push_back(recipe)
	pass

func LoadRecipes():
	
	#Miner
	Global.constructionManual.CreateRecipe(true,[],["Element-VK"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Mean Looking Crystals"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Pseudo Iron"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Purplutide"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Smooth Stuff"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Volcanite"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Wonksten"],"Miner Block")
	Global.constructionManual.CreateRecipe(true,[],["Oil"],"Miner Block")
	
	#Tinkerer
	Global.constructionManual.CreateRecipe(true,["Any resource","Any resource","Any resource","Any resource","Any resource"],["Drill Bit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(true,["Any resource","Any resource","Any resource","Any resource","Any resource"],["Conveyor Kit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(true,["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Circuit"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(true,["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Components"],"Tinkerer Block")
	Global.constructionManual.CreateRecipe(true,["Any resource","Any resource","Any resource","Any resource","Any resource"],["Simple Motor"],"Tinkerer Block")
	
	#Simple constructor
	Global.constructionManual.CreateRecipe(false,["Pseudo Iron","Smooth Stuff"],["Conductive Plating"],"Simple Constructor Block")
	Global.constructionManual.CreateRecipe(false,["Conductive Plating","Element-VK"],["Wire"],"Simple Constructor Block")
	
	
func SearchRecipesWithOutput(output:String)->Array[ConstructionRecipe]:
	var result: Array[ConstructionRecipe]
	
	for recipe in recipes:
		for _output in recipe.outputResources:
			if _output == output:
				result.push_back(recipe)
	
	return result
	pass
	
func OpenRecipesWithOutput(output:String):
	#print("asfasf",output)
	relevantRecipes.clear()
	relevantRecipes = SearchRecipesWithOutput(output)
	recipeHead = 0
	if(relevantRecipes.size() == 0):
		
		return
	DisplayRecipe(relevantRecipes[recipeHead])
		
func DisplayRecipe(recipe: ConstructionRecipe):
	#print(relevantRecipes.size())
	recipeWindow.visible = false
	
	for i in 5:
		inputBoxes[i].visible = false
		outputBoxes[i].visible = false
		inputArrows[i].visible = false
		outputArrows[i].visible = false
		inputLabels[i].visible = false
		outputLabels[i].visible = false
	
	var constructorBlock:Block = Global.buildMenu.GetBlockReferenceByName(recipe.constructorBlock)
	if constructorBlock == null:
		blockIcon.texture = load("res://Sprites/Resources/placeholder.png")
		recipeNameLabel.text = str("Recipe using <error>")
	else: 
		blockIcon.texture = constructorBlock.menuIcon
		recipeNameLabel.text = str("Recipe using ", constructorBlock.blockName)
	
	var i :int = 0
	inputBase.position.y = basesDefaultHeight + 50
	for resource in recipe.inputResources:
		inputArrows[i].visible = true
		var _resource : ResourceTuple = Global.resourceManager.GetResourceByName(resource)
		if _resource.resourceName == "Error":
			inputLabels[i].text = resource
			inputLabels[i].visible = true
		else: 
			inputIcons[i].texture = _resource.texture
			inputBoxes[i].visible = true
		inputBase.position.y = inputBase.position.y - 50
		i = i + 1
	
	i = 0
	outputBase.position.y = basesDefaultHeight + 50
	for resource in recipe.outputResources:
		outputArrows[i].visible = true
		var _resource : ResourceTuple = Global.resourceManager.GetResourceByName(resource)
		if _resource == null:
			outputLabels[i].text = resource
			outputLabels[i].visible = true
		else :
			outputIcons[i].texture = _resource.texture
			outputBoxes[i].visible = true
		outputBase.position.y = outputBase.position.y - 50
		i = i + 1
		
	#TODO hide the empty boxes and move the input and output bases
	
	recipeWindow.visible = true
	
	pass
	


func _on_recipe_window_close_button_down():
	recipeWindow.visible = false
	pass # Replace with function body.


func _on_next_button_down():
	
	recipeHead = recipeHead + 1
	if recipeHead > relevantRecipes.size()-1:
		recipeHead = 0
	DisplayRecipe(relevantRecipes[recipeHead])
	pass # Replace with function body.


func _on_prev_button_down():
	recipeHead = recipeHead - 1
	if recipeHead == -1:
		recipeHead = relevantRecipes.size()-1
	DisplayRecipe(relevantRecipes[recipeHead])
	pass # Replace with function body.
