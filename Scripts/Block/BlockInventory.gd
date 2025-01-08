extends Object
class_name BlockInventory

var itemNames: Array[String]#h   s        a      e        i     k     d
var itemAmount: Array[int]#t   e    e         r       l      n     e
var xPosition: int
var yPosition: int


func PushBack(_item:String, _itemAmount:int):
	var i: int = 0
	for item in itemNames:
		if _item == item:
			itemAmount[i] = itemAmount[i] + _itemAmount
			return
		i=i+1
	
	itemNames.push_back(_item)
	itemAmount.push_back(_itemAmount)
	
	pass
	
func GetAsResourceTupleArray()-> Array[ResourceTuple]:
	var array: Array[ResourceTuple]
	
	var i: int = 0
	for item in itemNames:
		var tuple: ResourceTuple = ResourceTuple.new()
		tuple.resourceName = item
		tuple.amount = itemAmount[i]
		array.push_back(tuple)
		i=i+1
	return array
	pass

func Clear():
	itemNames.clear()
	itemAmount.clear()
