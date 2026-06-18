extends Camera2D

var zoom_velocity
var target_zoom

func _ready() -> void:
	zoom_velocity = 0

func _physics_process(delta: float) -> void:
	if zoom.x < target_zoom:
		zoom_velocity += 0.2
	else:
		zoom_velocity -= 0.2
	zoom_velocity * 0.99
	zoom.x += zoom_velocity
	zoom.y += zoom_velocity

func _on_bullet_current_speed(speed: int) -> void:
	target_zoom = 1.0 + sqrt(speed)
