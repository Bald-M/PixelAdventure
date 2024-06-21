extends KinematicBody2D

var enemyDeathScene = preload("res://scenes/EnemyDeath.tscn")
var baseLevelScene = preload("res://scenes/BaseLevel.tscn")

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500
export var maxSpeed = 45
var startDirection = Vector2.RIGHT
var motion = Vector2.ZERO

const deathTimeout = 30  # Boss 死亡的等待时间，单位秒
var currentTimer = 0  # 当前计时器

var player = null
var player_in_detection_area = false 

func _ready():
	direction = startDirection
	var baseLevel = baseLevelScene.instance()
	player = baseLevel.get_node("PlayerRoot/Player")
	
	# Connect signal for player entering detection area
	$DetectionArea.connect("body_entered", self, "_on_detection_area_body_entered")
	$DetectionArea.connect("body_exited", self, "_on_detection_area_body_exited")
	$DeathTimer.connect("timeout", self, "_on_death_timer_timeout")
	
	# Start the death timer
#	$DeathTimer.wait_time = deathTimeout
#	$DeathTimer.one_shot = true
#	$DeathTimer.connect("timeout", self, "_on_death_timer_timeout")
#	$DeathTimer.start()
	$DeathTimer.start()


func _physics_process(delta):
	if player != null and player_in_detection_area:
		motion = position.direction_to(player.position) * maxSpeed
	else:
		motion = Vector2.ZERO
	motion = move_and_slide(motion)
	
	
	#$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false

func kill():
	var deathInstance = enemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if (velocity.x > 0):
		deathInstance.scale = Vector2(-1, 1)

	var character = load("res://assets/boss/character_0021.png")
	deathInstance.init(character)

	queue_free()


func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		player = body
		player_in_detection_area = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		player = null
		player_in_detection_area = false


func _on_DeathTimer_timeout():
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
