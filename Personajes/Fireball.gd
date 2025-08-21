extends RigidBody2D

const SPEED = 200

func _ready():
	gravity_scale = 0
	linear_velocity = Vector2(-SPEED, 0)
	angular_damp = 1000000

	add_to_group("Fireball")  # Añadir el nodo al grupo Fireball

	var timer = Timer.new()
	timer.wait_time = 20.0
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(self._on_Timer_timeout)
	timer.start()

func _integrate_forces(_state):
	linear_velocity = Vector2(-SPEED, 0)
	rotation = 0

func _on_Timer_timeout():
	queue_free()
