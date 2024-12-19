extends Block

func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass
	
func CreepDamage(damage: int):
	
	print(name, ": Damage taken")
	
	hp = hp - damage
	
	if hp < 0:
		Global.gameManager.GameOver()
		pass
	
	pass
