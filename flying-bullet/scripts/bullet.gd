extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: float)

const INITIAL_LINEAR_VELOCITY = Vector2.RIGHT * 3.33
const MAX_HEALTH = 3
const LINEAR_ACCELERATION = 0.0
const ROTATIONAL_ACCELERATION = 0.02
const LINEAR_DRAG_LINEAR_FACTOR_COEFFICIENT = 0.0015
const LINEAR_DRAG_ROTATIONAL_FACTOR_COEFFICIENT = 0.0
const ROTATIONAL_DRAG_LINEAR_FACTOR_COEFFICIENT = 0.00225
const ROTATIONAL_DRAG_ROTATIONAL_FACTOR_COEFFICIENT = 6.7
const SCORE_GAIN_ON_BOUNCE = 5
const FPS_DEVELOPED_IN = 60
const BOUNCED_LINEAR_VELOCITY_COEFFICIENT = 2.0
const DRAG_EXPONENT = 2.0

var previous_collisions_collider
var health
var score
var turn_direction
var linear_velocity
var rotational_velocity

enum Direction {
	LEFT = -1, 
	RIGHT = 1,
	NEUTRAL = 0,
}

func _ready() -> void:
	#Engine.physics_ticks_per_second = 60
	#Engine.max_physics_steps_per_frame = 4
	#Engine.time_scale = 1.0
	previous_collisions_collider = StaticBody2D.new()
	rotation = 0.0
	turn_direction = Direction.NEUTRAL
	linear_velocity = INITIAL_LINEAR_VELOCITY
	rotational_velocity = 0.0
	health = MAX_HEALTH
	score = 0


func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_pressed("turn_right"):
		turn_direction = Direction.RIGHT
	elif Input.is_action_pressed("turn_left"):
		turn_direction = Direction.LEFT
	else:
		turn_direction = Direction.NEUTRAL
	get_viewport().set_input_as_handled()


func _process(_delta: float) -> void:
	emit_signal("current_score", score)
	emit_signal("current_health", health)


func _physics_process(delta: float) -> void:
	var special_delta = delta * FPS_DEVELOPED_IN
	
	var speed = linear_velocity.length()
	emit_signal("current_speed", speed)
	
	if turn_direction != null:
		rotational_velocity += turn_direction * ROTATIONAL_ACCELERATION * special_delta
	var rotational_drag = _drag_calculated(rotational_velocity * ROTATIONAL_DRAG_ROTATIONAL_FACTOR_COEFFICIENT + (speed if rotational_velocity >= 0 else -speed) * ROTATIONAL_DRAG_LINEAR_FACTOR_COEFFICIENT)
	rotational_velocity /= rotational_drag * special_delta
	rotation += rotational_velocity * special_delta
	
	linear_velocity = Vector2.from_angle(rotation) * speed + Vector2.from_angle(rotation) * LINEAR_ACCELERATION * special_delta
	var linear_drag = _drag_calculated(speed * LINEAR_DRAG_LINEAR_FACTOR_COEFFICIENT + rotational_velocity * LINEAR_DRAG_ROTATIONAL_FACTOR_COEFFICIENT)
	linear_velocity /= linear_drag * special_delta
	
	var collision = move_and_collide(linear_velocity)
	if collision != null:
		var bounce_was_successful = attempt_bounce(collision)
		if not bounce_was_successful:
			pass


func _drag_calculated(_velocity: float) -> float:
	var drag = 1 + _velocity * _velocity
	return drag


func attempt_bounce(collision: KinematicCollision2D) -> bool:
	var collision_normal = collision.get_normal()
	var collisions_collider = collision.get_collider()
	var saved_position = position
	var saved_rotation = rotation
	
	previous_collisions_collider = StaticBody2D.new()
	
	rotation = Vector2.from_angle(rotation).bounce(collision_normal).angle()
	position = collision.get_position()
	if in_area_of_previous_collisions_collider():
		position = saved_position
		rotation = saved_rotation
		return false
	
	linear_velocity = linear_velocity.bounce(collision_normal) * BOUNCED_LINEAR_VELOCITY_COEFFICIENT
	
	
	score += SCORE_GAIN_ON_BOUNCE
	
	if collisions_collider.has_method("material_bounciness"):
		linear_velocity *= collisions_collider.acceleration_multiplication_from_collision()
	
	previous_collisions_collider.set_collision_layer_value(1, true)
	collisions_collider.set_collision_layer_value(1, false)
	previous_collisions_collider = collisions_collider
	
	return true


func in_area_of_previous_collisions_collider() -> bool:
	var collision
	
	previous_collisions_collider.set_collision_layer_value(1, true)
	collision = move_and_collide(Vector2.ZERO, true)
	previous_collisions_collider.set_collision_layer_value(1, false)
	
	if collision != null:
		if collision.get_collider() == previous_collisions_collider:
			return true
	return false
