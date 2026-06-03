extends CanvasLayer

const HEART = preload("res://scenes/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for heart in %Bullet.hearts :
		%Hearts.add_child(HEART.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
