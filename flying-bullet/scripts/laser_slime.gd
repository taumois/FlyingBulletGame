extends RigidBody2D

const LINEAR_ACCELERATION = 50000.0
const ROTATIONAL_ACCELERATION = 100000.0
const LASER_DAMAGE = 1
const DEATH_EXPLOSION = preload("res://scenes/death_explosion.tscn")

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
	laser_sound = %LaserSound
	bullet = get_parent().bullet

func _physics_process(delta: float) -> void:
	apply_torque(ROTATIONAL_ACCELERATION * delta)
	apply_force(Vector2.from_angle(self.global_position.angle_to_point(bullet.global_position)) * LINEAR_ACCELERATION * delta)
	
	if laser_cooldown.is_stopped() and laser_point.is_colliding():
		var collider = laser_point.get_collider()
		if collider.has_method("damage"):
			laser.show()
			laser_visual_duration.start()
			laser_sound.play()
			laser_cooldown.start()
			collider.damage(LASER_DAMAGE);


func damage(_amount: int) -> void:
	_die()


func _die() -> void:
	var explosion = DEATH_EXPLOSION.instantiate()
	explosion.position = position
	add_sibling(explosion)
	queue_free()


func _on_laser_visual_duration_timeout() -> void:
	laser.hide()
