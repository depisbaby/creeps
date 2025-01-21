extends Block
class_name ChestBlock

var blockInventory :BlockInventory

func ReceiveResource(resource: _Resource, source:Block):
	super.ReceiveResource(resource, source)
	
	blockInventory.PushBack(resource.resourceName, 1)
	Global.resourceManager.ReturnToPool(resource)
	
	
func PlayerInteract():
	Global.inventoryMenu.CollectResources(blockInventory.GetAsResourceTupleArray())
	blockInventory.Clear()
	pass
	
func OnPlace():
	super.OnPlace()
	blockInventory = BlockInventory.new()
	blockInventory.xPosition = xGridPos
	blockInventory.yPosition = yGridPos
	Global.saveManager.Subscribe(self)
	pass
	
func Save():
	var save = Global.saveManager.loadedWorldData
	save.blockInventories.push_back(blockInventory)
	pass
	
func Load():
	pass
