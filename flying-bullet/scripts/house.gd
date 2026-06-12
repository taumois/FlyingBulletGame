extends StaticBody2D

const acceleration_multiplication_from_collision_for_bullet = 2.5
const points_from_collision_for_bullet = 50


func acceleration_multiplication_from_collision() -> float:
	return acceleration_multiplication_from_collision_for_bullet
	
func points_from_collision() -> float:
	return points_from_collision_for_bullet
