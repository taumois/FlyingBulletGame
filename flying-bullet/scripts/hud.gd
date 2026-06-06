extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for heart in %Bullet.MAX_HEARTS:
		%Hearts.add_child(HEART.instantiate())


func update_score() -> void:
	%Score.text = "Score: "+%Bullet.score


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
