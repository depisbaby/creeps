extends Block

var fuse :int

func OnPlace():
	super.OnPlace()
	fuse = 60 * 5
	
func _physics_process(delta: float) -> void:
	if !placed:
		return
	
	fuse = fuse - 1
	if fuse == 0:
		Global.worldManager.CreateExplosion(xGridPos,yGridPos, 50, 4)
		#print("fdafdsf")
	pass
