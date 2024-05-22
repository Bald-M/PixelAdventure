extends KinematicBody2D

const UP = Vector2.UP

var maxSpeed = 30
var gravity = 500
var velocity = Vector2.ZERO
var direction = Vector2.RIGHT

onready var ledgeCheckRight: = $LedgeCheckRight
onready var ledgeCheckLeft: = $LedgeCheckLeft
onready var sprite: = $AnimatedSprite

func _ready():
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
	var hitWall = is_on_wall()
	var foundLedge = not ledgeCheckLeft.is_colliding() or not ledgeCheckRight.is_colliding()

	# print(is_on_floor())
	
	if foundLedge or hitWall:
		# reverse walk path
		direction *= -1
		
	velocity.x = (direction * maxSpeed).x
	# Apply gravity
	# velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP)
	
	sprite.flip_h = true if direction.x > 0 else false

func on_hitbox_entered(area2d):
	queue_free()
