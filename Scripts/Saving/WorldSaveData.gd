extends Resource
class_name WorldSaveData

@export var slotNumber: int
@export var seed: String

#world
@export var worldChanges: Array

#player
@export var playerPosition: Vector2

#block inventories
@export var blockInventories: Array

#out of pool resources
@export var outOfPoolResources: Array
