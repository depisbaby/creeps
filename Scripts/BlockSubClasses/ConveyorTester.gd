extends ConveyorBlock

@export var isSpawner: bool
@onready var timer: Timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super._process(delta)
	pass

func OnPlace():
	super.OnPlace()
	if isSpawner:
		SpawnResources()

func SpawnResources():
	timer.start(1)
	await timer.timeout
	resourceStorage.storage[1] = resourceStorage.storage[1] + 1
	hasResources = true
	print("spawned")
	SpawnResources()
	
func ReceiveResources(resources:Array[int], source : Block):
	super.ReceiveResources(resources, source)
	print("detected")
	pass
