extends Node2D

func _ready():
	$DeathSoundPlayer1.play()
	$DeathSoundPlayer2.play()

	var character = load("res://assets/crimsonMechonid/character_0016.png")
	playDead(character)

func playDead(character):
	$Particles2D.texture = character
	
func init(character):
	playDead(character)
