extends RigidBody2D

const LINEAR_ACCELERATION = 1000.0;
const ROTATIONAL_ACCELERATION = 100000.0;
const MAX_HEALTH = 100

var health
var bullet
var laser_point: RayCast2D
var laser_duration: Timer
var laser_cooldown: Timer
var laser: Area2D

func _ready() -> void:
	laser_point = %LaserPoint
	laser_duration = %LaserDuration
	laser_cooldown = %LaserCooldown
	laser = %Laser
	linear_damp = 1.0
	angular_damp = 1.0
	bullet = get_tree().root.get_node("World/Bullet")
	health = MAX_HEALTH

func _physics_process(delta: float) -> void:
	var angle_to_bullet = get_angle_to(bullet.position)
	if angle_to_bullet > 0.0:
		apply_torque(-ROTATIONAL_ACCELERATION * delta)
	else:
		apply_torque(ROTATIONAL_ACCELERATION * delta)
	apply_force(Vector2.from_angle(angle_to_bullet) * LINEAR_ACCELERATION * delta)
	if laser_cooldown.is_stopped():
		var laser_collision_position
		if laser_point.is_colliding():
			laser_collision_position = laser_point.get_collision_point()
		else:
			laser_collision_position = global_position
		laser.scale.y = global_position.distance_to(laser_collision_position) / 20.0
		laser.position = Vector2.from_angle(get_angle_to(laser_collision_position)) * laser.scale.y * 10.0


func damage_from_collision() -> int:
	return 1


func _on_laser_cooldown_timeout() -> void:
	laser_duration.start()
	laser.show()


func _on_laser_duration_timeout() -> void:
	laser_cooldown.start()
	laser.hide()
