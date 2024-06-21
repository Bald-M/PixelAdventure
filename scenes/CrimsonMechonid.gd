extends KinematicBody2D

var enemyDeathScene = preload("res://scenes/EnemyDeath.tscn")

export var isSpawning = true
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500
export var maxSpeed = 20
var startDirection = Vector2.RIGHT

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft

func _ready():
	direction = startDirection
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
	var hitWall = is_on_wall()
	var foundLedge = not ledgeCheckLeft.is_colliding() or not ledgeCheckRight.is_colliding()
	
	if foundLedge or hitWall:
		# reverse walk path
		direction *= -1
	
	if (isSpawning):
		return

	velocity.x = (direction * maxSpeed).x
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false

func kill():
	var deathInstance = enemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if (velocity.x > 0):
		deathInstance.scale = Vector2(-1, 1)
	
	var character = load("res://assets/crimsonMechonid/character_0015.png")
	deathInstance.init(character)
	queue_free()

func on_goal_entered(_area2d):
	direction *= -1;

func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
