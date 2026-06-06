extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")
const  SCORE_TEXT = "Score: {0}"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score(1)
	for heart in %Bullet.MAX_HEARTS:
		%Hearts.add_child(HEART.instantiate())


func update_score(score: int) -> void:
	%Score.text = SCORE_TEXT.format([score])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_bullet_score_updated(score: int) -> void:
	update_score(score)
