extends CharacterBody2D

# Make rotation actually acceleration based
# keep turning changing momentum direction
# fine tune acceleration, drag, etc, values
# switch from move_and_collide() to move_and_slide()
# add speed number to HUD

const MAX_HEARTS = 3
const ROTATIONAL_ACCELERATION = 5 / 0.017
const LINEAR_ACCELERATION = 0.65 / 0.017
const linear_drag = 1.02
const rotational_drag = 1.005


var blacklistedCollisionId
var hearts
var score


func _ready() -> void:
	self.blacklistedCollisionId = null
	self.hearts = MAX_HEARTS
	var score = 0


func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	velocity = velocity / linear_drag
	
	var wants_to_turn_left = Input.is_action_pressed("turn_left")
	var wants_to_turn_right = Input.is_action_pressed("turn_right")
	var rotation_direction = (-1 if wants_to_turn_left else 0 + 1 if wants_to_turn_right else 0)
	if rotation_direction != 0:
		rotate(rotation_direction * ROTATIONAL_ACCELERATION / velocity.length_squared() * delta)
		velocity = Vector2.from_angle(rotation) * (velocity.length() * 0.9)
	
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
	
	var collisionNormal = collision.get_normal()
	self.velocity = velocity.bounce(collisionNormal)
	self.rotation = self.velocity.angle()
	self.position = collision.get_position() + self.velocity.normalized() * 1
	
	self.velocity *= 2
	
	
	
