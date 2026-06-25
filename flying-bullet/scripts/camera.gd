extends Camera2D

const BASE_POSITION_SMOOTHING_SPEED = 0.5
const BASE_ROTATION_SMOOTHING_SPEED = 0.085


func _on_camera_manipulator_current_scale(everything_scale: float) -> void:
	var scale_is_valid = everything_scale < 1.0
	if scale_is_valid:
		zoom.x = everything_scale
		zoom.y = everything_scale
	
	position_smoothing_speed = BASE_POSITION_SMOOTHING_SPEED / everything_scale
	rotation_smoothing_speed = BASE_ROTATION_SMOOTHING_SPEED / everything_scale
