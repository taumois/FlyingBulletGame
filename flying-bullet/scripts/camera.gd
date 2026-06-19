extends Camera2D

const ZOOM_SCALE_COEFFICIENT = 0.5

func _on_bullet_current_speed(speed: float) -> void:
	var target_zoom = 1.0 / (sqrt(speed) * ZOOM_SCALE_COEFFICIENT)
	
	var target_zoom_is_valid = target_zoom < 1.0 && target_zoom > 0.0
	if target_zoom_is_valid:
		zoom.x = target_zoom
		zoom.y = target_zoom
