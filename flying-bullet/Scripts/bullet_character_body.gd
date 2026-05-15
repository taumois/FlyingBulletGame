extends RigidBody2D

const ACCELERATION = 500
const BURST_ACCELERATION = 10000
const TURNING_ACCELERATION = 5000


func _ready() -> void:
	$BurstCooldown.start()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var a = self.position
	var direction_to_cursor = self.position.direction_to(get_global_mouse_position())
	if state.get_contact_count() > 0 || $BurstCooldown.time_left == 0:
		state.apply_force(Vector2(direction_to_cursor * BURST_ACCELERATION))
		$BurstCooldown.start()
	state.apply_force(Vector2(direction_to_cursor * ACCELERATION))


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass
