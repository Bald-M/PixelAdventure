extends KinematicBody2D

signal died

enum State { NORMAL, DASHING } 

const UP = Vector2.UP
var velocity = Vector2.ZERO
export var gravity = 1000
export var maxHorizontalSpeed = 140
export var jumpSpeed = 360
export var horizontalAcceleration = 2000
export var jumpTerminationMultiplier = 3
export var maxDashSpeed = 300
export var minDashSpeed = 100
export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var hasDoubleJump = false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask = 0

func _ready():
	# Face towards right at beginning
	$AnimatedSprite.flip_h = true
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask

func _process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false
	
	
func change_state(newState):
	currentState = newState
	isStateNew = true
	
func process_normal(delta):
	if (isStateNew):
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
	var moveVector = get_movement_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	# Apply gravity to the player
	velocity.y += gravity * delta
	
	if (moveVector.x == 0):
		velocity.x = lerp(0,velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if (moveVector.y < 0 && (is_on_floor() || hasDoubleJump)):
		velocity.y = moveVector.y * jumpSpeed
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			hasDoubleJump = false

	if (velocity.y < 0 && !Input.is_action_pressed("move_up")):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
			
	var wasOnFloor = is_on_floor()
	
	velocity = move_and_slide(velocity,UP)
	
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
		hasDoubleJump = true
		
	if (Input.is_action_just_pressed("dash")):
		# change_state(State.DASHING)
		call_deferred("change_state", State.DASHING)
		
	update_animation()
	

func process_dash(delta):
	if (isStateNew):
		$HazardArea.collision_mask = dashHazardMask
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		var moveVector = get_movement_vector()
		var velocityMod = 1
		if (moveVector.x != 0):
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1
		
		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	
	velocity = move_and_slide(velocity, UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))
	
	if (abs(velocity.x) < minDashSpeed):
		call_deferred("change_state", State.NORMAL)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("move_up") else 0
	return moveVector
	
func update_animation():
	var moveVec = get_movement_vector()
	
	if(!is_on_floor()):
		$AnimatedSprite.play("jump")
	elif (moveVec.x != 0):
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if (moveVec.x != 0):
		$AnimatedSprite.flip_h = true if moveVec.x > 0 else false
		
func on_hazard_area_entered(area2d):
	emit_signal("died")
	
