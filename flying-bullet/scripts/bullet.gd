extends CharacterBody2D


const MAX_HEARTS = 3
const ACCELERATION = 100

var hearts

func _ready() -> void:
	hearts = MAX_HEARTS

func _physics_process(delta: float) -> void:
	var acceleration
	
	move_and_collide(acceleration)
