extends RigidBody2D

const LINEAR_ACCELERATION = 100000.0
const ROTATIONAL_ACCELERATION = 500000.0
const LASER_DAMAGE = 1

var health
var bullet
var laser_point: RayCast2D
var laser_duration: Timer
var laser_cooldown: Timer
var laser: Sprite2D

func _ready() -> void:
	laser_point = %LaserPoint
	laser_duration = %LaserDuration
	laser_cooldown = %LaserCooldown
	laser = %Laser
	linear_damp = 1.0
	angular_damp = 1.0
	bullet = get_tree().root.get_node("World/Bullet")

func _physics_process(delta: float) -> void:
	#apply_torque(ROTATIONAL_ACCELERATION * delta)
	
	var angle_to_bullet = get_angle_to(bullet.position)
	look_at(bullet.position)
	apply_force(Vector2.from_angle(angle_to_bullet) * LINEAR_ACCELERATION * delta)
	
	if laser_cooldown.is_stopped():
		var laser_collision_position
		if laser_point.is_colliding():
			laser_collision_position = laser_point.get_collision_point()
			var collider = laser_point.get_collider()
			if collider.has_method("damage"):
				print(1)
				collider.damage(LASER_DAMAGE);
				laser_duration.stop()
				laser_duration.timeout.emit()
		else:
			laser_collision_position = position
		laser.position = laser_collision_position
		#laser.position = Vector2.from_angle(get_angle_to(laser_collision_position)) * laser.scale.y


func damage(_amount: int) -> void:
	queue_free()


func _on_laser_cooldown_timeout() -> void:
	laser_duration.start()
	laser.show()


func _on_laser_duration_timeout() -> void:
	laser_cooldown.start()
	laser.hide()
