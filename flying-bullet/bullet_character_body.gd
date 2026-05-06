extends RigidBody2D

const SPEED = 0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var direction = self.position.direction_to(get_local_mouse_position())
	apply_force(Vector2(direction * SPEED * delta / 0.0333))
	if self.rotation > self.position.direction_to(get_local_mouse_position()).angle():
		apply_torque(500)
		print(1453256)
	else:
		apply_torque(-500)
		print(0)
	rotate()
	#print(self.rotation_degrees)
	#print(rad_to_deg(direction.angle())-90)
