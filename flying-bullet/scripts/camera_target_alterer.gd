extends Node2D

signal current_scale(scale: float)

const SCALE_COEFFICIENT = 1.0
const VIEWPORT_FRACTION_OFFSET = 0.25

var offset_size
var parent

func _ready() -> void:
	get_tree().root.size_changed.connect(viewport_rect_updated)
	parent = get_parent()
	viewport_rect_updated()


func viewport_rect_updated():
	var viewport_width = get_viewport_rect().size.x
	offset_size = viewport_width * VIEWPORT_FRACTION_OFFSET


func _on_bullet_current_speed(speed: float) -> void:
	var scale = 1.0 / (sqrt(speed) * SCALE_COEFFICIENT)
	emit_signal("current_scale", scale)
	
	var parent_rotation_vector = Vector2.from_angle(parent.rotation)
	var offset_vector = parent_rotation_vector / scale * offset_size
	
	global_position = parent.global_position + offset_vector
