extends RigidBody2D

const LINEAR_ACCELERATION = 1000.0
const LASER_DAMAGE = 1

var health
var bullet
var laser_point: RayCast2D
var laser_visual_duration: Timer
var laser_cooldown: Timer
var laser: Sprite2D
var laser_sound: AudioStreamPlayer

func _ready() -> void:
	laser_point = %LaserPoint
	laser_visual_duration = %LaserVisualDuration
	laser_cooldown = %LaserCooldown
	laser = %Laser
	linear_damp = 1.0
	angular_damp = 1.0
	laser_sound = %LaserSound
	bullet = get_tree().root.get_node("World/Bullet")

func _physics_process(delta: float) -> void:
	#apply_torque(ROTATIONAL_ACCELERATION * delta)
	
	look_at(bullet.position)
	apply_force(Vector2.from_angle(rotation) * LINEAR_ACCELERATION * delta)
	
	if laser_cooldown.is_stopped() and laser_point.is_colliding():
		var collider = laser_point.get_collider()
		if collider.has_method("damage"):
			laser.show()
			laser_visual_duration.start()
			laser_sound.play()
			laser_cooldown.start()
			collider.damage(LASER_DAMAGE);
		print(position)


func damage(_amount: int) -> void:
	queue_free()


func _on_laser_visual_duration_timeout() -> void:
	laser.hide()
