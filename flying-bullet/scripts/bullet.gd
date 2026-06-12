extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: int)

const MAX_HEALTH = 3
const LINEAR_ACCELERATION = 0.5 / 0.01666666666667
const LINEAR_SLIPPERINESS = 0.99 / 0.01666666666667
const ROTATIONAL_ACCELERATION = 0.005 / 0.01666666666667
const ROTATIONAL_SLIPPERINESS = 0.9 / 0.01666666666667
const MAGIC_ROTATION_DRAG_VALUE = 0.1

var previous_collisions_collider
var health
var score
var turn_direction
var rotational_velocity

enum Direction {
	LEFT = -1, 
	RIGHT = 1,
	NEUTRAL = 0,
}

func _ready() -> void:
	previous_collisions_collider = StaticBody2D.new()
	velocity = Vector2.ZERO
	turn_direction = Direction.NEUTRAL
	rotational_velocity = 0.0
	health = MAX_HEALTH
	score = 0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("turn_left"):
		turn_direction = Direction.LEFT
	elif event.is_action_released("turn_left"):
		turn_direction = Direction.NEUTRAL
	if event.is_action_pressed("turn_right"):
		turn_direction = Direction.RIGHT
	elif event.is_action_released("turn_right"):
		turn_direction = Direction.NEUTRAL
	get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	emit_signal("current_score", score)
	emit_signal("current_health", health)


func drag_multiplier_from_rotational_velocity() -> float:
	var modified_rotational_velocity = maxf(absf(rotational_velocity), 1)
	var x = MAGIC_ROTATION_DRAG_VALUE * modified_rotational_velocity
	return 1 / x


func _physics_process(delta: float) -> void:
	if turn_direction != null:
		rotational_velocity += turn_direction * ROTATIONAL_ACCELERATION * delta
	rotation += rotational_velocity
	rotational_velocity *= ROTATIONAL_SLIPPERINESS * delta
	
	velocity = Vector2.from_angle(rotation) * velocity.length() + Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	velocity *= LINEAR_SLIPPERINESS * drag_multiplier_from_rotational_velocity() * delta
	print(drag_multiplier_from_rotational_velocity())
	
	if not in_area_of_previous_collisions_collider():
		previous_collisions_collider.set_collision_layer_value(1, true)
	
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
	
	emit_signal("current_speed", velocity.length())


func bounce(collision: KinematicCollision2D) -> void:
	var collision_normal = collision.get_normal()
	var collisions_collider = collision.get_collider()
	
	velocity = velocity.bounce(collision_normal)
	rotation = Vector2.from_angle(rotation).bounce(collision_normal).angle()
	position = collision.get_position()
	
	if collisions_collider.has_method("score_from_collision"):
		score += collisions_collider.score_from_collision()
	
	if collisions_collider.has_method("acceleration_multiplication_from_collision"):
		velocity *= collisions_collider.acceleration_multiplication_from_collision()
	
	previous_collisions_collider.set_collision_layer_value(1, true)
	collisions_collider.set_collision_layer_value(1, false)
	previous_collisions_collider = collisions_collider


func in_area_of_previous_collisions_collider() -> bool:
	var collision
	
	previous_collisions_collider.set_collision_layer_value(1, true)
	collision = move_and_collide(Vector2.ZERO, true)
	previous_collisions_collider.set_collision_layer_value(1, false)
	
	return collision != null
