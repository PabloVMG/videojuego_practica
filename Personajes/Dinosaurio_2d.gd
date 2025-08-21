extends CharacterBody2D

const FIREBALL_SCENE = preload("res://Personajes/fireball.tscn")  # Ajusta la ruta a tu escena de bola de fuego

var fire_timer: Timer

func _ready():
	# Configura un temporizador para lanzar bolas de fuego aleatoriamente
	fire_timer = Timer.new()
	fire_timer.wait_time = randf_range(1.0, 3.0)  # Intervalo aleatorio entre 1 y 3 segundos
	fire_timer.one_shot = false
	fire_timer.connect("timeout", Callable(self, "_on_FireTimer_timeout"))
	add_child(fire_timer)
	fire_timer.start()

func _on_FireTimer_timeout():
	var fireball = FIREBALL_SCENE.instantiate()
	var fire_point = $FirePoint.global_position  # Usa la posición global del punto de emisión
	fireball.position = fire_point
	get_parent().add_child(fireball)
	# Reinicia el temporizador con un nuevo intervalo aleatorio
	fire_timer.wait_time = randf_range(0.5, 5.0)
	fire_timer.start()

func _on_area_2d_area_shape_entered(_area_rid, _area, _area_shape_index, _local_shape_index, body):
	print("nbnjhsbfjbdfjsbfjdsf", _area.name)
