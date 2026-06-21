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
	position = Vector2.ONE * 10_000
	#Engine.physics_ticks_per_second = 60
	#Engine.max_physics_steps_per_frame = 4
	#Engine.time_scale = 1.0
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
		bounce(collision)
	

func _drag_calculated(_velocity: float) -> float:
	var drag = 1 + _velocity * _velocity
	return drag


func bounce(collision: KinematicCollision2D) -> void:
	var collision_normal = collision.get_normal()
	var collisions_collider = collision.get_collider()
	var saved_position = position
	var saved_rotation = rotation
	
	linear_velocity = linear_velocity.bounce(collision_normal) * BOUNCED_LINEAR_VELOCITY_COEFFICIENT
	rotation = linear_velocity.angle()
	
	position = collision.get_position()
	unstuck_forwards_from_collision(collision)
	
	score += SCORE_GAIN_ON_BOUNCE
	
	if collisions_collider.has_method("material_bouaaaaaaanciness"):
		linear_velocity *= collisions_collider.acceleration_multiplication_from_collision()


func unstuck_forwards_from_collision(collision: KinematicCollision2D) -> void:
	var forwards = Vector2.from_angle(rotation) * 10.0
	var stuck = true
	while stuck:
		position += forwards
		var updated_collision = move_and_collide(Vector2.ZERO, true)
		if updated_collision == null:
			stuck = false
		elif collision.get_collider_id() != collision.get_collider_id():
			stuck = false
			bounce(updated_collision)
