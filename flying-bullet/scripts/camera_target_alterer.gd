extends Node2D

signal current_scale(scale: float)

const PERM_SCALE_COEFFICIENT = 1.0
const VIEWPORT_FRACTION_OFFSET = 0.25

var offset_size
var parent
var scale_coefficient = 10.0

func _ready() -> void:
	parent = get_parent()
	get_tree().root.size_changed.connect(viewport_rect_updated)
	viewport_rect_updated()


func viewport_rect_updated():
	var viewport_width = get_viewport_rect().size.x
	offset_size = viewport_width * VIEWPORT_FRACTION_OFFSET


func _on_bullet_current_speed(speed: float) -> void:
	var scale = 1.0 / (sqrt(speed) * scale_coefficient)
	emit_signal("current_scale", scale)
	
	var parent_rotation_vector = Vector2.from_angle(parent.rotation)
	var offset_vector = parent_rotation_vector / scale * offset_size
	
	global_position = parent.global_position + offset_vector


func _on_initial_pan_timer_timeout() -> void:
	scale_coefficient = PERM_SCALE_COEFFICIENT
