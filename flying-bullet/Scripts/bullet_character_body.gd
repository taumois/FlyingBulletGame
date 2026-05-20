extends RigidBody2D

const ACCELERATION = 100
const BURST_ACCELERATION = 0
const TURNING_ACCELERATION = 5000


func _ready() -> void:
	$BurstCooldown.start()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var vector_to_cursor = self.position.direction_to(get_global_mouse_position())
	
	var isColliding = (state.get_contact_count() > 0)
	var burstCoolDownUp = ($BurstCooldown.time_left == 0)
	if isColliding || burstCoolDownUp:
		state.apply_impulse(Vector2(vector_to_cursor * BURST_ACCELERATION * 0.033))
		$BurstCooldown.start()
	state.apply_force(Vector2(vector_to_cursor * ACCELERATION))
	
	#var x = state.linear_velocity.angle()
	#x = Vector2.from_angle(x)
	#x = x.rotated(deg_to_rad(90.0))
	#var y = self.global_rotation
	#y = Vector2.from_angle(y)
	#var z = (x-y).length()
	#apply_force(Vector2(100/z * x))
	var x = self.rotation + deg_to_rad(-90)
	var y = state.linear_velocity.angle()
	var z = rad_to_deg(angle_difference(x, y))
	if z > 180:
		#print('_')
		pass
	else:
		pass
		#print(abs(z))
	var w = Vector2(-state.linear_velocity*abs(z/100))
	print(w.length())
	state.apply_force(w)
	state.apply_force(w.rotated(deg_to_rad(z)))
	state.apply_torque(state.linear_velocity.length_squared()*z/100)
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass
