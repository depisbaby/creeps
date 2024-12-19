extends Object
class_name ResourceStorage

var storage: Array[int]

func _init():
	storage = [
		0, #empty
		0, #1 = energy
	]
	pass
	
func Clear():
	storage.fill(0)
