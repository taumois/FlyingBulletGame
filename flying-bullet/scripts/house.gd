extends StaticBody2D

const acceleration_multiplication_from_collision_for_bullet = 1.2
const score_from_collision_for_bullet = 10


func acceleration_multiplication_from_collision() -> float:
	return acceleration_multiplication_from_collision_for_bullet
	
func score_from_collision() -> float:
	return score_from_collision_for_bullet
