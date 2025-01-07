extends Control
class_name Tooltips

@onready var resourceTooltip: Control = $ResourceToolTip
@onready var resourceTooltipLabel: Label = $ResourceToolTip/Label

@onready var blockTooltip: Control = $BlockTooltip
@onready var blockTooltipName: Label = $BlockTooltip/nameLabel
@onready var blockTooltipDesc: RichTextLabel = $BlockTooltip/RichTextLabel
@onready var blockTooltipComponents: RichTextLabel = $BlockTooltip/components
var examinedBlock: Block
var examinedResource: ResourceTuple

func _enter_tree():
	Global.tooltips = self
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func StartShowingResourceTooltip(resourceName:String):
	resourceTooltipLabel.text = resourceName
	resourceTooltip.visible = true
	pass

func StopShowingResourceTooltip():
	resourceTooltip.visible = false
	pass
	
func StartShowingBlockTooltip(block:Block):
	blockTooltipName.text = block.blockName
	blockTooltipDesc.text = block.desc
	blockTooltipComponents.text = "Components required: "
	
	var i :int = 0
	for component in block.components:
		var text: String = ""
		
		for collected in Global.inventoryMenu.collectedResources:
			if component == collected.resourceName && block.componentAmounts[i] >= collected.amount:
				text = str("[color=#008000]",block.componentAmounts[i], "x ", component,"[/color], ")
				break
		
		if text == "":
			text = str("[color=#ff0000]",block.componentAmounts[i], "x ", component,"[/color], ")
		
		blockTooltipComponents.text = str(blockTooltipComponents.text, text)
		
		i = i + 1
	blockTooltip.visible = true
	pass
	
func StopShowingBlockTooltip():
	blockTooltip.visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
