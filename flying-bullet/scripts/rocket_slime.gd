extends RigidBody2D

const LINEAR_ACCELERATION = 20000.0
const ROTATIONAL_ACCELERATION = 100000.0
const ROCKET_DAMAGE = 1
const ROCKET = preload("res://scenes/rocket.tscn")

var bullet

func _ready() -> void:
	bullet = get_parent().bullet


func _physics_process(delta: float) -> void:
	apply_torque(ROTATIONAL_ACCELERATION * delta)
	apply_force(Vector2.from_angle(self.global_position.angle_to_point(bullet.global_position)) * LINEAR_ACCELERATION * delta)


func damage(_amount: int) -> void:
	queue_free()


func _on_rocket_cooldown_timeout() -> void:
	add_child(ROCKET.instantiate())
