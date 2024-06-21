extends HBoxContainer

func _ready():
	var baseLevels = get_tree().get_nodes_in_group("base_level")
	
	if (baseLevels.size() > 0):
		baseLevels[0].connect("diamond_total_changed", self, "on_diamond_total_changed")
		update_display(baseLevels[0].totalDiamonds, baseLevels[0].collectedDiamonds)
		
func update_display(totalDiamonds, collectedDiamonds):
	$DiamondLabel.text = str(collectedDiamonds, "/", totalDiamonds)

func on_diamond_total_changed(totalDiamonds, collectedDiamonds):
	update_display(totalDiamonds, collectedDiamonds)
