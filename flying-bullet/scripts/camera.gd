extends Camera2D

const ZOOM_SCALE_COEFFICIENT = 0.5

func _on_bullet_current_speed(speed: float) -> void:
	var target_scale = 1.0 / (sqrt(speed) * ZOOM_SCALE_COEFFICIENT)
	
	var target_scale_is_valid = target_scale < 1.0 && target_scale > 0.0
	if target_scale_is_valid:
		zoom.x = target_scale
		zoom.y = target_scale
	
	rotation_smoothing_speed = 1.0 / target_scale
	position_smoothing_speed = 1.0 / target_scale
