extends RigidBody2D

const LINEAR_ACCELERATION = 100;
const MAX_HEALTH = 100

var health
var bullet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet = get_tree().root.get_node("World/Bullet")
	health = MAX_HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var angle_to_bullet = get_angle_to(bullet.position)
	state.apply_force(Vector2.from_angle(angle_to_bullet) * LINEAR_ACCELERATION)

func damage_from_collision() -> int:
	return


func damage(int) -> void
