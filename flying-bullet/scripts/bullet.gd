extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: int)

const MAX_HEALTH = 3
const LINEAR_ACCELERATION = 0.05
const ROTATIONAL_ACCELERATION = 0.005
const BASE_LINEAR_RESISTANCE = 1.0
const BASE_ROTATIONAL_RESISTANCE = 1.0
const LINEAR_RESISTANCE = 0.0
const ROTATIONAL_RESISTANCE = 0.0

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
	rotation = 0.0
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


func _physics_process(delta: float) -> void:
	if turn_direction != null:
		rotational_velocity += turn_direction * ROTATIONAL_ACCELERATION
	rotational_velocity /= pow((1.0 + absf(velocity.length()) * ROTATIONAL_RESISTANCE) * (1 + BASE_ROTATIONAL_RESISTANCE), 2.0)
	rotation += rotational_velocity
	
	velocity = Vector2.from_angle(rotation) * velocity.length() + Vector2.from_angle(rotation) * LINEAR_ACCELERATION
	velocity /= pow((1.0 + absf(rotational_velocity) * LINEAR_RESISTANCE) * (1 + BASE_LINEAR_RESISTANCE), 2.0)
	
	if (previous_collisions_collider.get_collision_layer_value(1) == false) and (not in_area_of_previous_collisions_collider()):
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
