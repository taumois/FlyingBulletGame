extends RigidBody2D

const ACCELERATION = 1000
const TURNING_ACCELERATION = 5000


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var direction_to_cursor = self.position.direction_to(get_global_mouse_position())
	if self.position.distance_to(get_global_mouse_position()) > 250:
		apply_force(Vector2(direction_to_cursor * ACCELERATION))
	else:
		apply_force(Vector2(direction_to_cursor * ACCELERATION/2))
	
	var angle_degress_to_cursor = rad_to_deg(self.position.direction_to(get_local_mouse_position()).angle())
	
	#if angle_degress_to_cursor < 90 && angle_degress_to_cursor > -90:
		#apply_torque(TURNING_ACCELERATION)
	#else:
		#apply_torque(TURNING_ACCELERATION * -1)
	
	var angle_degress_to_velocity = rad_to_deg(self.position.direction_to(state.linear_velocity).angle())
	
	#if angle_degress_to_velocity < 90 && angle_degress_to_velocity > -90:
		#apply_torque(state.linear_velocity.length())
	#else:
		#apply_torque(state.linear_velocity.length() * -1)
	apply_force(state.linear_velocity.rotated(angle_degress_to_velocity) * -10)
