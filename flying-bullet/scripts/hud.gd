extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")

var recorded_health;
var recorded_speed;
var time
var acceleration


func _ready() -> void:
	recorded_health = 0
	recorded_speed = 0
	acceleration = 0


func _process(_delta: float) -> void:
	pass


func _on_bullet_current_health(health: int) -> void:
	for health_point in (health - recorded_health):
		%Hearts.add_child(HEART.instantiate())
	for health_point in (recorded_health - health):
		%Hearts.get_child(0).queue_free()
	recorded_health = health


func _on_bullet_current_score(score: int) -> void:
	%Score.text = "Score {0}".format([score])


func _on_bullet_current_speed(speed: int) -> void:
	acceleration = abs(recorded_speed - speed)
	%Speed.text = "Acceleration {0}m/s/s".format([acceleration])
	%Acceleration.text = "Speed {0}".format([speed])
	recorded_speed = speed
