extends CharacterBody2D

signal current_score(score: int)
signal current_health(health: int)
signal current_speed(speed: int)

const MAX_HEALTH = 3
const LINEAR_ACCELERATION = 0.03 / 0.01666666666667
const LINEAR_SLIPPERINESS = 1 / 0.01666666666667

var lastCollisionsCollider
var health
var score

func _ready() -> void:
	health = MAX_HEALTH
	score = 0
<<<<<<< Updated upstream

func _process(_delta: float) -> void:
	emit_signal("current_score", score)
	emit_signal("current_health", health)
=======
	emit_signal("score_updated", score)
	emit_signal("health_updated", health)

func _process(_delta: float) -> void:
	pass
	
>>>>>>> Stashed changes

func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	#velocity *= LINEAR_SLIPPERINESS * delta
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
<<<<<<< Updated upstream
	
	emit_signal("current_speed", velocity.length())
=======
>>>>>>> Stashed changes


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
<<<<<<< Updated upstream
=======
	health -= 1
	emit_signal("health_updated", health)
>>>>>>> Stashed changes


class x:
	var _health
