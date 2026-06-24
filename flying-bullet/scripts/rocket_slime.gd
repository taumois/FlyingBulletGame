extends RigidBody2D

const LINEAR_ACCELERATION = 80000.0
const ROTATIONAL_ACCELERATION = 3000000.0
const ROCKET_DAMAGE = 1

var bullet

func _ready() -> void:
	bullet = %Bullet


func _physics_process(delta: float) -> void:
	apply_torque(ROTATIONAL_ACCELERATION * delta)
	apply_force(Vector2.from_angle(self.global_position.angle_to_point(bullet.global_position)) * LINEAR_ACCELERATION * delta)


func damage(_amount: int) -> void:
	queue_free()
