extends Block
class_name ChestBlock

var collectedResources: Array[ResourceTuple]

func ReceiveResource(resource: _Resource, source:Block):
	super.ReceiveResource(resource, source)
	
	for _resource in collectedResources:
		if _resource.resourceName == resource.resourceName:
			_resource.amount = _resource.amount + 1
			Global.resourceManager.ReturnToPool(resource)
			return
	
	var instance = ResourceTuple.new()
	instance.resourceName = resource.resourceName
	instance.amount = 1
	instance.texture = resource.texture
	collectedResources.push_back(instance)
	
	Global.resourceManager.ReturnToPool(resource)
	
func PlayerInteract():
	Global.inventoryMenu.CollectResources(collectedResources)
	collectedResources.clear()
	pass
