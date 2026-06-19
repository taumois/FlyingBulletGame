extends RigidBody2D

const LINEAR_ACCELERATION = 1000.0;
const MAX_HEALTH = 100

var health
var bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_damp = 1.0
	angular_damp = 1.0
	bullet = get_tree().root.get_node("World/Bullet")
	health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	var angle_to_bullet = get_angle_to(bullet.position)
	apply_force(Vector2.from_angle(angle_to_bullet) * LINEAR_ACCELERATION)


func damage_from_collision() -> int:
	return 0
