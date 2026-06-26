extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: float)

const DAMAGE_EXPLOSION = preload("res://scenes/death_explosion.tscn")
const COLLISION_DAMAGE_TO_ENEMIES = 1
const SCORE_GAIN_FROM_DEALING_DAMAGE = 499
const INITIAL_SPEED = 35.0
const INITIAL_HEALTH = 10
const LINEAR_ACCELERATION = 0.0
const LINEAR_DRAG_COEFFICIENT = 0.00015
const ROTATIONAL_ACCELERATION = 0.0035
const ROTATIONAL_DRAG_COEFFICIENT = 0.6
const SCORE_GAIN_ON_BOUNCE = 5
const FPS_DEVELOPED_IN = 60
const BOUNCED_LINEAR_VELOCITY = 100.0
const DRAG_EXPONENT = 2.0
const COLLISION_LIMIT = 1

var collision_limit_timer: Timer
var health
var score
var turn_direction
var linear_velocity
var rotational_velocity
var collision_count

enum Direction {
	LEFT = -1, 
	RIGHT = 1,
	NEUTRAL = 0,
}

func _ready() -> void:
	collision_count = 0
	position = Vector2.ZERO
	rotation = 0.0
	turn_direction = Direction.NEUTRAL
	linear_velocity = Vector2.ONE * INITIAL_SPEED
	rotational_velocity = 0.0
	health = INITIAL_HEALTH
	score = 0


func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("turn_right"):
		turn_direction = Direction.RIGHT
	elif Input.is_action_pressed("turn_left"):
		turn_direction = Direction.LEFT
	else:
		turn_direction = Direction.NEUTRAL
	get_viewport().set_input_as_handled()


func special_physics_process(delta: float) -> void:
	var special_delta = delta * FPS_DEVELOPED_IN
	
	var speed = linear_velocity.length() * special_delta
	emit_signal("current_speed", speed)
	
	if turn_direction != null:
		rotational_velocity += turn_direction * ROTATIONAL_ACCELERATION * special_delta
	var rotational_drag = rotational_velocity * rotational_velocity * ROTATIONAL_DRAG_COEFFICIENT
	if rotational_velocity > 0.0:
		rotational_drag *= -1
	rotational_velocity += rotational_drag * special_delta
	rotation += rotational_velocity * special_delta
	
	linear_velocity = Vector2.from_angle(rotation) * speed
	linear_velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * special_delta
	var linear_drag = speed * speed * LINEAR_DRAG_COEFFICIENT * -1
	linear_velocity += Vector2.from_angle(rotation) * linear_drag * special_delta
	
	var collision = move_and_collide(linear_velocity)
	if collision != null:
		bounce(collision)


func damage(amount: int) -> void:
	health -= amount
	if health < 0:
		health = 0
	emit_signal("current_health", health)
	do_explosion()


func do_explosion() -> void:
	var explosion = DAMAGE_EXPLOSION.instantiate()
	explosion.position = position
	add_sibling(explosion)


func bounce(collision: KinematicCollision2D) -> void:
	var collision_normal = collision.get_normal()
	
	var collision_collider = collision.get_collider()
	if collision_collider.has_method("damage"):
		collision_collider.damage(COLLISION_DAMAGE_TO_ENEMIES);
		if collision_collider.has_method("explode"):
			collision_collider.explode(self);
		else:
			score += SCORE_GAIN_FROM_DEALING_DAMAGE
	
	var bounce_vector = linear_velocity.bounce(collision_normal)
	var bounce_vector_angle = bounce_vector.angle()
	linear_velocity = bounce_vector.normalized() * BOUNCED_LINEAR_VELOCITY
	rotation = bounce_vector_angle
	position += linear_velocity
	
	score += SCORE_GAIN_ON_BOUNCE
	emit_signal("current_score", score)
