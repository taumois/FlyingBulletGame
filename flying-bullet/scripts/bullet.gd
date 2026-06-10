extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: int)

const MAX_HEALTH = 3
const LINEAR_ACCELERATION = 0.5 / 0.01666666666667
const LINEAR_SLIPPERINESS = 0.99 / 0.01666666666667
const ROTATIONAL_ACCELERATION = 0.005 / 0.01666666666667
const ROTATIONAL_SLIPPERINESS = 0.9 / 0.01666666666667
const DRAG_FROM_ROTATION = 0.5 / 0.01666666666667

var lastCollisionsCollider
var health
var score
var turn_direction
var rotational_velocity

enum Direction {
	LEFT = -1, 
	RIGHT = 1,
}

func _ready() -> void:
	velocity = Vector2.ZERO
	rotational_velocity = 0.0
	health = MAX_HEALTH
	score = 0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("turn_left"):
		turn_direction = Direction.LEFT
		get_viewport().set_input_as_handled()
	elif event.is_action("turn_right"):
		turn_direction = Direction.RIGHT
		get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	emit_signal("current_score", score)
	emit_signal("current_health", health)

func _physics_process(delta: float) -> void:
	if turn_direction != null:
		rotational_velocity += turn_direction * ROTATIONAL_ACCELERATION * delta
	rotational_velocity = fmod(rotational_velocity, 360.0)
	rotation += rotational_velocity
	rotational_velocity *= ROTATIONAL_SLIPPERINESS * delta
	
	velocity = Vector2.from_angle(rotation) * velocity.length() + Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	var a = 1 / (maxf(1 + (rotational_velocity / 360.0), 1) * (1.0 / DRAG_FROM_ROTATION))
	a = absf(a)
	print(a)
	velocity *= LINEAR_SLIPPERINESS * delta * a
	
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
	
	emit_signal("current_speed", velocity.length())


func bounce(collision: KinematicCollision2D) -> void:
	var collisionNormal
	
	if lastCollisionsCollider != null:
		lastCollisionsCollider.set_collision_layer_value(1, true)
	lastCollisionsCollider = collision.get_collider()
	lastCollisionsCollider.set_collision_layer_value(1, false)
	
	collisionNormal = collision.get_normal()
	velocity = velocity.bounce(collisionNormal)
	rotation = Vector2.from_angle(rotation).bounce(collisionNormal).angle()
	position = collision.get_position()
