extends Control
class_name InventoryMenu

@onready var gridStart: Control = $gridStart
var collectedResources: Array[ResourceTuple]
@onready var resourcePanel: PackedScene = preload("res://UIScenes/resource_panel.tscn")
var grid: Array[ResourcePanel]

func _enter_tree():
	Global.inventoryMenu = self
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.saveManager.Subscribe(self)
	InitializeGrid()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func OpenView():
	UpdateGrid()
	visible = true

func _on_close_button_down():
	visible = false
	Global.soundManager.PlayClick()
	pass # Replace with function body.
	
func InitializeGrid():
	var i: int
	for y in 20:
		for x in 25:
			var instance: ResourcePanel = resourcePanel.instantiate()
			add_child(instance)
			instance.position = gridStart.position + Vector2(x*40, y*40)
			instance.visible = false
			grid.push_back(instance)
			
		
func CollectResources(resources: Array[ResourceTuple]):
	#print("aaaaaaaaaaa")
	for resource in resources:
		var hasAlready: bool
		for collected in collectedResources:
			if resource.resourceName == collected.resourceName:
				collected.amount = collected.amount + resource.amount
				hasAlready = true
				break
				
		if hasAlready:
			continue
			
		var instance = ResourceTuple.new()
		instance.resourceName = resource.resourceName
		instance.amount = resource.amount
		instance.texture = resource.texture
		if resource.texture == null:
			instance.texture = Global.resourceManager.GetResourceByName(resource.resourceName).texture
		collectedResources.push_back(instance)
	
	Global.effectManager.DisplayStatusIcon(Global.player.global_position,10)
	
	pass
	
func GiveResource(resourceName:String, amount: int):
	for collected in collectedResources:
		if resourceName == collected.resourceName:
			collected.amount = collected.amount + amount
			return			
	
	collectedResources.push_back(Global.resourceManager.NewResourceTuple(resourceName,amount,true))
				
	pass
	
func TakeResource(resourceName:String, amount: int): 
	var toRemove: ResourceTuple
	for collected in collectedResources:
		if resourceName == collected.resourceName && collected.amount >= amount:
			collected.amount = collected.amount - amount
			if collected.amount <= 0:
				toRemove = collected
	
	if toRemove != null:
		collectedResources.erase(toRemove)
	
	pass

func RequireResources(requiredResources:Array[ResourceTuple], takeAfterCheck: bool)-> bool:
	for required in requiredResources:
		var has: bool = false
		for collected in collectedResources:
			if collected.resourceName == required.resourceName && collected.amount >= required.amount:
				has = true
				break
		
		if !has:
			return false
	
	#has all required resources
	if takeAfterCheck:
		for required in requiredResources:
			print(required.resourceName, " ", required.amount)
			TakeResource(required.resourceName, required.amount)
	
	
	return true
	
	pass
	
func GetResourcesFromDisassembledBlock(block: Block):
	var i: int = 0
	for resource in block.components:
		GiveResource(resource, block.componentAmounts[i])
		i = i +1
	pass
	
func UpdateGrid():
	for panel in grid:
		panel.visible = false
	var gridHead: int = 0
	for collected in collectedResources:
		grid[gridHead].sprite.texture = collected.texture
		if collected.amount > 999:
			grid[gridHead].amountLabel.text = str("999+")
		else :
			grid[gridHead].amountLabel.text = str(collected.amount)
		grid[gridHead].visible = true
		gridHead = gridHead + 1

func Save():
	var save = Global.saveManager.loadedCharacterData
	
	for collectedResource in collectedResources:
		save.playerInventory.push_back(collectedResource)
	pass
	
func Load():
	var save = Global.saveManager.loadedCharacterData
	for collectedResource in save.playerInventory:
		collectedResources.push_back(collectedResource)
	pass
	
