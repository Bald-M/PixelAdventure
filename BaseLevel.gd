extends Node

signal coin_total_changed

var playerScene = preload("res://scenes/Player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null
var totalCoins = 0
var collectedCoins = 0

func _ready():
	spawnPosition = $Player.global_position
	register_player($Player)
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())
	
	$Flag.connect("player_won", self, "on_player_won")

	

func coin_collected():
	collectedCoins += 1
	print(totalCoins, " " ,collectedCoins)
	emit_signal("coin_total_changed",totalCoins,collectedCoins)
	
func coin_total_changed(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died")
	
func create_player():
	var playerInstance = playerScene.instance()
	playerInstance.global_position = spawnPosition
	add_child_below_node(currentPlayerNode, playerInstance)
	register_player(playerInstance)
	
func on_player_died():
	currentPlayerNode.queue_free()
	create_player()
	
func on_player_won():
	print("hi you win")
	$"/root/LevelManager".increment_level()