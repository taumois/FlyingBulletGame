extends CharacterBody2D

# Make rotation actually acceleration based
# keep turning changing momentum direction
# fine tune acceleration, drag, etc, values
# add speed number to HUD

const MAX_HEARTS = 3
const LINEAR_ACCELERATION = 0.01 / 0.01666666666667
const LINEAR_SLIPPERINESS = 1 / 0.01666666666667

var lastCollisionsCollider
var hearts
var score

func _ready() -> void:
	hearts = MAX_HEARTS
	score = 0

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	#velocity *= LINEAR_SLIPPERINESS * delta
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)


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
