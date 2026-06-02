extends RigidBody2D

const ACCELERATION = 1000
const BURST_ACCELERATION = 0
const TURNING_ACCELERATION = 5000


func _ready() -> void:
	$BurstCooldown.start()


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass
