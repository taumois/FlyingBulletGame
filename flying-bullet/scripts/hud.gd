extends CanvasLayer

var recorded_health
var recorded_score
var health_label
var score_label
var show_health_timer
var show_score_timer
var tutorial_screen
var death_screen
var end_screen_duration

func _ready() -> void:
	health_label = %Health
	score_label = %Score
	show_health_timer = %ShowHearts
	show_score_timer = %ShowScore
	tutorial_screen = %TutorialScreen
	death_screen = %DeathScreen
	end_screen_duration = %EndScreenDuration
	recorded_health = 0
	recorded_score = 0
	
	health_label.hide()
	score_label.hide()


func _on_bullet_current_health(health: int) -> void:
	if health == recorded_health:
		return
	if health <= 0:
		player_died()
	
	health_label.text = str(health)
	
	score_label.hide()
	health_label.show()
	show_health_timer.start()
	
	recorded_health = health


func player_died() -> void:
	Engine.time_scale = 0.0
	health_label.hide()
	score_label.show()
	death_screen.show()
	end_screen_duration.start()


func _on_bullet_current_score(score: int) -> void:
	if score == recorded_score or not show_health_timer.is_stopped():
		return
	
	score_label.text = str(score)
	
	score_label.show()
	show_score_timer.start()
	
	recorded_score = score


func _on_show_hearts_timer_timeout() -> void:
	if show_score_timer.time_left > 0.0:
		score_label.show()
		
	health_label.hide()


func _on_show_score_timeout() -> void:
	score_label.hide()


func _on_end_screen_duration_timeout() -> void:
	get_tree().reload_current_scene()
