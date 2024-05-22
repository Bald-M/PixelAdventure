extends Node2D

export(Color, RGB) var backgroundColour

func _ready():
	VisualServer.set_default_clear_color(backgroundColour)
	
