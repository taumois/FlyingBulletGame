extends TextureRect


# Called when the node enters the scene tree for the first time.
func _input(event: InputEvent) -> void:
	if event.is_pressed():
		queue_free()


func _on_tutorial_screen_duration_timeout() -> void:
	queue_free()
