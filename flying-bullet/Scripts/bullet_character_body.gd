extends RigidBody2D

const ACCELERATION = 10000
const TURNING_ACCELERATION = 500000
const MAX_HEARTS = 5

var hearts


func _ready() -> void:
	hearts = MAX_HEARTS
	$BurstCooldown.start()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	apply_force(Vector2.from_angle(self.rotation) * ACCELERATION * delta)
	
	if Input.is_action_pressed("ui_left"):
		apply_torque(-TURNING_ACCELERATION * delta)
	if Input.is_action_pressed("ui_right"):
		apply_torque(TURNING_ACCELERATION * delta)
	
	var x = self.linear_velocity.angle_to(Vector2.from_angle(self.rotation))
	var force = Vector2(sin(x), cos(x)) * ACCELERATION
	#print(round(force.length()/1000)*1000)
	#if x > 0:
		#force = force.rotated(deg_to_rad(90))
	#else:
		#force = force.rotated(deg_to_rad(-90))
	apply_force(force * delta / 750)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	apply_impulse(self.linear_velocity)
