extends CPUParticles2D

func _ready() -> void:
	%ExplosionSound.volume_db = 250.0
	%ExplosionSound.pitch_scale = randf_range(0.75, 1.25)
	%ExplosionSound.play()
	emitting = true


func _on_explosion_sound_finished() -> void:
	queue_free()
