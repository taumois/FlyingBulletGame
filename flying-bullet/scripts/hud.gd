extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")
const UNIT_A_TO_B_MULT = 100

var recorded_health;
var recorded_speed;
var recorded_time;

func _ready() -> void:
	Engine.time_scale = 1
	recorded_health = 0
	recorded_speed = 0
	recorded_time = 0


func _process(_delta: float) -> void:
	pass


func _on_bullet_current_health(health: int) -> void:
	for health_point in (health - recorded_health):
		%Hearts.add_child(HEART.instantiate())
	for health_point in (recorded_health - health):
		%Hearts.get_child(0).queue_free()
	recorded_health = health


func _on_bullet_current_score(score: int) -> void:
	%Score.text = "Score: {0}".format([score])


func _on_bullet_current_speed(speed: float) -> void:
	var c_time = Time.get_ticks_msec()
	var time = c_time - recorded_time
	time /= 1000.0
	speed /= time * 1 / 0.017
	print(speed)
	var speed_in_unit_b = unit_b_from_a(speed)
	var acceleration = abs(speed_in_unit_b - unit_b_from_a(recorded_speed))

	%Speed.text = "Acceleration: {0}x/s/s".format([roundf(acceleration)])
	%Acceleration.text = "Speed: {0}x/s".format([roundf(speed_in_unit_b)])
	
	recorded_speed = speed
	recorded_time = c_time


func unit_b_from_a(a: float) -> float:
	var b = a * UNIT_A_TO_B_MULT
	return b
