extends RigidBody2D

const ACCELERATION = 10000
const TURNING_ACCELERATION = 500000
const MAX_HEARTS = 5

var hearts


func _ready() -> void:
	hearts = MAX_HEARTS


func _process(_delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		apply_force(Vector2.from_angle(self.rotation) * ACCELERATION * delta)
	
	if Input.is_action_pressed("ui_left"):
		apply_torque(-TURNING_ACCELERATION * delta)
	if Input.is_action_pressed("ui_right"):
		apply_torque(TURNING_ACCELERATION * delta)
	
	#var x = self.linear_velocity.angle_to(Vector2.from_angle(self.rotation))
	#var force = Vector2(sin(x), cos(x)) * ACCELERATION
	##print(round(force.length()/1000)*1000)
	##if x > 0:
		##force = force.rotated(deg_to_rad(90))
	##else:
		##force = force.rotated(deg_to_rad(-90))
	#apply_force(force * delta / 750)


func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	#set_lock_rotation_enabled(true)
	#$BounceDelay.start()
	#print(0)
	pass

func _on_bounce_length_timeout() -> void:
	var x = Vector2(2.2, 8.059)
	$CollisionShape.scale = x
	set_lock_rotation_enabled(false)
	print(2)


func _on_bounce_delay_timeout() -> void:
	$CollisionShape.scale = Vector2.ZERO
	set_rotation(get_angle_to(self.linear_velocity))
	$BounceLength.start()
	print(1)
