extends Node2D

var base_level

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")
	
func on_area_entered(area2d):
	var baseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()
	queue_free()
	
func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
	
