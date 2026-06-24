extends RigidBody2D

const LINEAR_ACCELERATION = 500000.0
const DAMAGE = 1

var bullet

func _ready() -> void:
	bullet = get_parent().bullet


func _physics_process(delta: float) -> void:
	apply_force(Vector2.from_angle(self.global_position.angle_to_point(bullet.global_position)) * LINEAR_ACCELERATION * delta)


func damage(_amount: int) -> void:
	queue_free()


func explode(body: Node) -> void:
	if body.has_method("damage"):
		body.damage(DAMAGE)
	queue_free()
