extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")
<<<<<<< Updated upstream
=======

var recorded_health = 0
>>>>>>> Stashed changes

var recorded_health;
var time
var acceleration


func _ready() -> void:
<<<<<<< Updated upstream
	recorded_health = 0
	acceleration = 0


=======
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
>>>>>>> Stashed changes
func _process(_delta: float) -> void:
	pass


<<<<<<< Updated upstream
func _on_bullet_current_health(health: int) -> void:
	for health_point in (health - recorded_health):
		%Hearts.add_child(HEART.instantiate())
	for health_point in (recorded_health - health):
		%Hearts.get_child(0).queue_free()
	recorded_health = health


func _on_bullet_current_score(score: int) -> void:
	%Score.text = "Score {0}".format([score])


func _on_bullet_current_speed(speed: int) -> void:
	time = time - Time.get_ticks_msec()
	%Speed.text = "Speed {0}".format([acceleration])
=======
func _on_bullet_score_updated(score: int) -> void:
	%Score.text = "Score: {0}".format([score])


func _on_bullet_health_updated(health: int) -> void:
	for i in health - recorded_health:
		%Hearts.add_child(HEART.instantiate())
	for i in recorded_health - health:
		at
		%Hearts.get_child(0).queue_free()
	recorded_health = health
>>>>>>> Stashed changes
