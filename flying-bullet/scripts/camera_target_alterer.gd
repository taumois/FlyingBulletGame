extends Node2D

const OFFSET_COEFFICIENT = 0.5

var bullet
var offset
var viewport_width

func _ready() -> void:
	bullet = get_parent()
	offset = 0
	viewport_width  = get_viewport_rect().size.x


func _process(delta: float) -> void:
	global_position = bullet.global_position + Vector2.from_angle(bullet.rotation) * viewport_width * 0.5
	print(offset)


func _on_bullet_current_speed(speed: float) -> void:
	offset = pow(speed, 0.25) * OFFSET_COEFFICIENT
