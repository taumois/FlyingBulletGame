extends RigidBody2D

const SPEED = 360


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var direction = self.position.direction_to(get_global_mouse_position())
	apply_force(Vector2(direction * SPEED))
