extends Camera2D

const ZOOM_SCALE_COEFFICIENT = 1.0

func _on_bullet_current_speed(speed: float) -> void:
	var target_zoom = 1 / sqrt(speed) * ZOOM_SCALE_COEFFICIENT
	zoom.x = target_zoom
	zoom.y = target_zoom
