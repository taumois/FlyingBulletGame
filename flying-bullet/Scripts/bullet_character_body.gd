extends RigidBody2D

const ACCELERATION = 5000
const TURNING_ACCELERATION = 500000


func _ready() -> void:
	$BurstCooldown.start()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	apply_force(Vector2.from_angle(self.rotation) * ACCELERATION * delta)
	
	if Input.is_action_pressed("ui_left"):
		apply_torque(-TURNING_ACCELERATION * delta)
	if Input.is_action_pressed("ui_right"):
		apply_torque(TURNING_ACCELERATION * delta)
	
	#if true:
		#apply_force(rotation_as_vector.rotated(deg_to_rad(90)) * 10)
	#else:
		#apply_force(rotation_as_vector.rotated(deg_to_rad(-90)) * 10)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass
