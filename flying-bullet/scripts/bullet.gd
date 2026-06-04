extends CharacterBody2D


const MAX_HEARTS = 3
const ACCELERATION = 1 / 0.017
const drag = 1.05

var hearts

func _ready() -> void:
	self.hearts = MAX_HEARTS

func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(self.rotation) * ACCELERATION
	
	velocity = velocity / drag
	
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		bounce(collision)


func bounce(collision: KinematicCollision2D) -> void:
	$CollisionPolygon2D.scale = Vector2.ZERO
	$BounceLength.start()
	collision.get_collider_id()
	self.position = collision.get_position()
	var collisionAngleVector = Vector2.from_angle(collision.get_angle())
	velocity = velocity.bounce(collisionAngleVector)
	rotation = Vector2.from_angle(rotation).bounce(collisionAngleVector).angle()


func _on_bounce_length_timeout() -> void:
	$CollisionPolygon2D.scale = Vector2.ONE
