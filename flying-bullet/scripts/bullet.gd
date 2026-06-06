extends CharacterBody2D

# Make rotation actually acceleration based
# keep turning changing momentum direction
# fine tune acceleration, drag, etc, values
# switch from move_and_collide() to move_and_slide()
# add speed number to HUD

const MAX_HEARTS = 3
const ROTATIONAL_ACCELERATION = 100
const LINEAR_ACCELERATION = 100
const linear_drag = 1.02
const rotational_drag = 0

var hasBlacklistedCollider
var blacklistedColliderId
var hearts
var score


func _ready() -> void:
	hasBlacklistedCollider = false
	hearts = MAX_HEARTS
	score = 0


func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	velocity = velocity / linear_drag 
	
	if Input.is_action_pressed("ui_accept"):
		Engine.time_scale = -1
	else:
		Engine.time_scale = 1
	
	#var _rotation_direction = (1 if Input.is_action_pressed("turn_left") else 0) + (-1 if Input.is_action_pressed("turn_right") else 0)
	#if Input.is_action_pressed("turn_left"):
		#_rotation_direction = -1
	
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
		print("col")
	else:
		hasBlacklistedCollider = false

func bounce(collision: KinematicCollision2D) -> void:
	var collisionId = collision.get_collider_id()
	if collisionId == blacklistedColliderId:
		return
	blacklistedColliderId = collisionId
	hasBlacklistedCollider = true
	
	var collisionNormal = collision.get_normal()
	velocity = velocity.bounce(collisionNormal)
	rotation = Vector2.from_angle(rotation).bounce(collisionNormal).angle()
	#position = collision.get_position()
	
	
	
