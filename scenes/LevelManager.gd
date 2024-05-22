extends Node

export(Array, PackedScene) var levelScenes

var currentLevelIndex = 1

func _ready():
	# get_tree().change_scene("res://Menu.tscn")
	change_level(currentLevelIndex)
	
func change_level(levelIndex):
	currentLevelIndex = levelIndex
	
	if (currentLevelIndex >= levelScenes.size()):
		currentLevelIndex = 0
		
	get_tree().change_scene(levelScenes[currentLevelIndex].resource_path)

func increment_level():
	change_level(currentLevelIndex + 1)
