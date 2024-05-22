extends Node2D

signal player_won

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(area2d):
	print("touch the flag")
	emit_signal("player_won")
	

