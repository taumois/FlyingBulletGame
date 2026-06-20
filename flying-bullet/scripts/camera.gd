extends Camera2D

const BASE_POSITION_SMOOTHING_SPEED = 0.5
const BASE_ROTATION_SMOOTHING_SPEED = 0.1

func _on_camera_manipulator_current_scale(scale: float) -> void:
	var scale_is_valid = scale < 1.0 && scale > 0.0
	if scale_is_valid:
		zoom.x = scale
		zoom.y = scale
	
	position_smoothing_speed = BASE_POSITION_SMOOTHING_SPEED / scale
	rotation_smoothing_speed = BASE_ROTATION_SMOOTHING_SPEED / scale
