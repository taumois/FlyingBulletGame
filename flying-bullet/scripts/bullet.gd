extends CharacterBody2D


const MAX_HEARTS = 3
const ROTATIONAL_ACCELERATION = 0.05 / 0.017
const LINEAR_ACCELERATION = 1 / 0.017
const drag = 1.05


var blacklistedCollisionId
var hearts


func _ready() -> void:
	self.hearts = MAX_HEARTS


func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(self.rotation) * LINEAR_ACCELERATION * delta
	velocity = velocity / drag
	
	var wants_to_turn_left = Input.is_action_pressed("turn_left")
	var wants_to_turn_right = Input.is_action_pressed("turn_right")
	var rotation_direction = (-1 if wants_to_turn_left else 0 + 1 if wants_to_turn_right else 0)
	if rotation_direction != 0:
		rotate(rotation_direction * ROTATIONAL_ACCELERATION * delta)
		velocity = velocity / drag
	
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
	else:
		blacklistedCollisionId = null


func bounce(collision: KinematicCollision2D) -> void:
	var collisionId = collision.get_collider_id()
	if collisionId == blacklistedCollisionId:
		return
	self.blacklistedCollisionId = collisionId
	
	self.position = collision.get_position()
	var collisionNormal = collision.get_normal()
	self.velocity = velocity.bounce(collisionNormal)
	self.rotation = velocity.angle()
