extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")
const UNIT_A_TO_B_MULT = 1

var recorded_health;

func _ready() -> void:
	recorded_health = 0


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
	var speed_in_unit_b = unit_b_from_a(speed)
	%Speed.text = "Speed: {0}x/s".format([roundf(speed_in_unit_b)])


func unit_b_from_a(a: float) -> float:
	var b = a * UNIT_A_TO_B_MULT
	return b
