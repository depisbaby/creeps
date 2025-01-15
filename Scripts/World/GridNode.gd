extends Node
class_name GridNode

var x:int
var y:int
var block: Block
var miningValue: float
var savingFlag: bool #used as an optimization when saving/loading changes

#liquids
var toxicSludge: float
