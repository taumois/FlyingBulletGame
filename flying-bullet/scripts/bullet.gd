extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: float)

const DAMAGE_EXPLOSION = preload("res://scenes/death_explosion.tscn")
const COLLISION_DAMAGE_TO_ENEMIES = 1
const SCORE_GAIN_FROM_DEALING_DAMAGE = 499
const INITIAL_SPEED = 35.0
const INITIAL_HEALTH = 10
const LINEAR_ACCELERATION = 0.085
const LINEAR_DRAG_COEFFICIENT = 0.0001
const ROTATIONAL_ACCELERATION = 0.01
const ROTATIONAL_DRAG_COEFFICIENT = 0.5
const SCORE_GAIN_ON_BOUNCE = 5
const FPS_DEVELOPED_IN = 60
const BOUNCED_LINEAR_VELOCITY_COEFFICIENT = 1.5
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
	collision_limit_timer = %ResetCollisionLimit
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
	
	var speed = linear_velocity.length()
	emit_signal("current_speed", speed)
	
	if turn_direction == Direction.NEUTRAL:
		rotational_velocity = 0.0
	else:
		var rotational_drag = rotational_velocity * rotational_velocity * ROTATIONAL_DRAG_COEFFICIENT * -sign(rotational_velocity)
		rotational_velocity += (turn_direction * ROTATIONAL_ACCELERATION + rotational_drag) * special_delta
		rotation += rotational_velocity
	
	var linear_drag = speed * speed * LINEAR_DRAG_COEFFICIENT * -1
	linear_velocity = Vector2.from_angle(rotation) * (speed + LINEAR_ACCELERATION + linear_drag) * special_delta
	
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
	var collision_collider_rid = collision.get_collider_rid()
	var pre_bounce_linear_velocity = linear_velocity
	
	var collision_collider = collision.get_collider()
	if collision_collider.has_method("damage"):
		collision_collider.damage(COLLISION_DAMAGE_TO_ENEMIES);
		if collision_collider.has_method("explode"):
			collision_collider.explode(self);
		else:
			score += SCORE_GAIN_FROM_DEALING_DAMAGE
	
	linear_velocity = linear_velocity.bounce(collision_normal) * BOUNCED_LINEAR_VELOCITY_COEFFICIENT
	rotation = linear_velocity.angle()
	
	position = collision.get_position() + pre_bounce_linear_velocity
	var stuck = true
	while(stuck):
		position += Vector2.from_angle(rotation)
		var stuck_collision = move_and_collide(Vector2.ZERO, true)
		if stuck_collision == null:
			position += Vector2.from_angle(rotation)
			stuck = false
		elif stuck_collision.get_collider_rid() != collision_collider_rid:
			bounce(stuck_collision)
			stuck = false
	
	score += SCORE_GAIN_ON_BOUNCE
	emit_signal("current_score", score)
	
	#if collision_limit_timer.is_stopped():
		#collision_limit_timer.start()
	#else:
		#collision_count += 1


#func _on_reset_collision_limit_timeout() -> void:
	#if collision_count > COLLISION_LIMIT:
		#position += Vector2.from_angle(rotation) * 1000.0
		#linear_velocity = INITIAL_LINEAR_VELOCITY
		#rotational_velocity = 0.0
	#collision_count = 0
