extends CharacterBody2D

# Make rotation actually acceleration based
# keep turning changing momentum direction
# fine tune acceleration, drag, etc, values
# switch from move_and_collide() to move_and_slide()
# add speed number to HUD

const MAX_HEARTS = 3
const LINEAR_ACCELERATION = 10
const linear_drag = 1.02 / 0.0166

var hasBlacklistedCollider
var blacklistedColliderId
var hearts
var score

var x = str

func _ready() -> void:
	hasBlacklistedCollider = false
	hearts = MAX_HEARTS
	score = 0


func _physics_process(delta: float) -> void:
	velocity += Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta
	#velocity /= linear_drag * delta
	
	var collision = move_and_collide(velocity)
	if collision != null:
		bounce(collision)
	else:
		hasBlacklistedCollider = false


func bounce(collision: KinematicCollision2D) -> void:
	var colliderId = collision.get_collider_id()
	if colliderIdIsBlacklisted(colliderId):
		return
	blacklistCollider(colliderId)
	
	self.set_collision_mask_value(1, false)
	var collisionNormal = collision.get_normal()
	print(collision.get_travel())
	velocity = velocity.bounce(collisionNormal)
	rotation = Vector2.from_angle(rotation).bounce(collisionNormal).angle()
	position = collision.get_position()


func colliderIdIsBlacklisted(id: int) -> bool:
	if hasBlacklistedCollider:
		if id == blacklistedColliderId:
			return true
	return false


func blacklistCollider(colliderId: int) -> void:
	blacklistedColliderId = colliderId
	hasBlacklistedCollider = true
