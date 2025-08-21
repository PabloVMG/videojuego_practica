extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -600.0
var dead = 0

# Obtener la gravedad de la configuración del proyecto para sincronizarla con los nodos RigidBody.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animation_tree : AnimationTree
var animation_state : AnimationNodeStateMachinePlayback
var current_direction = "right"  # Para rastrear la dirección actual del personaje
var death_label


func _ready():
	animation_tree = $AnimationTree
	animation_tree.active = true
	animation_state = animation_tree.get("parameters/playback")


	# Conectar la señal timeout del Timer a la función _on_Timer_timeout usando Callable
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))

	# Conectar la señal body_entered de Area2D a la función _on_area_2d_body_entered

	# Referenciar el nodo DeathLabel
	death_label = get_node_or_null("DeathLabel")  # Utiliza get_node_or_null para evitar errores si el nodo no se encuentra

	if death_label:
		death_label.visible = false
		print("DeathLabel está inicialmente oculto")
	else:
		print("DeathLabel no encontrado")

func _physics_process(delta):
	if dead == 1:
		return  # Omitir el resto del código si está muerto

	# Agregar la gravedad.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Manejar el salto.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if current_direction == "left":
			animation_state.travel("Saltar_Left")
		else:
			animation_state.travel("Saltar")

	# Manejar el ataque.
	if Input.is_action_just_pressed("Atacar"):
		if current_direction == "left":
			animation_state.travel("Atacar_Left")
		else:
			animation_state.travel("Atacar")
		return  # Omitir el resto del código para asegurar que la animación de ataque se reproduzca exclusivamente

	# Obtener la dirección de entrada y manejar el movimiento/desaceleración.
	var direction = Input.get_axis("ui_left", "ui_right")

	if is_on_floor():
		if direction == 1:
			velocity.x = direction * SPEED
			animation_state.travel("caminar")
			current_direction = "right"
		elif direction == -1:
			velocity.x = direction * SPEED
			animation_state.travel("Caminar_Left")
			current_direction = "left"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.x == 0:
				if animation_state.get_current_node() == "Caminar_Left" or animation_state.get_current_node() == "Saltar_Left":
					animation_state.travel("Idle_Left")
				elif animation_state.get_current_node() == "caminar" or animation_state.get_current_node() == "Saltar":
					animation_state.travel("Idle")
	else:
		# Permitir movimiento en el aire
		if direction != 0:
			velocity.x = direction * 150.0
			# Actualizar el estado de la animación según la dirección mientras está en el aire
			if direction == 1 and current_direction != "right":
				animation_state.travel("Saltar")
				current_direction = "right"
			elif direction == -1 and current_direction != "left":
				animation_state.travel("Saltar_Left")
				current_direction = "left"

		# Manejar animaciones en el aire si cambia la dirección
		if velocity.y < 0:  # El personaje se está moviendo hacia arriba (saltando)
			if current_direction == "left":
				animation_state.travel("Saltar_Left")
			else:
				animation_state.travel("Saltar")

	# Asegurarse de la animación de inactividad correcta al aterrizar
	if is_on_floor() and animation_state.get_current_node().begins_with("Saltar"):
		if current_direction == "left":
			animation_state.travel("Idle_Left")
		else:
			animation_state.travel("Idle")

	move_and_slide()

func _on_area_2d_body_entered(body):
	
	if body.name=="Senal":
		print("Pasando al siguiente nivel")
	if body.is_in_group("Fireball"):
		print("Colisión con Fireball")
		dead = 1
		handle_death()
	elif body.name.begins_with("Agua") or body.name.begins_with("@RigidBody2D")or body.name.begins_with("Fireball"):
		print("Colisión con Agua")
		dead = 1
	
		handle_death()
		
func handle_death():
	set_physics_process(false)
	animation_state.travel("Muerte")
	print("Muerte")
	print("Reiniciando el nivel")
	if death_label:
		death_label.text = "Has muerto\nReiniciando Nivel ..."
		death_label.visible = true
		print("Texto de DeathLabel configurado y hecho visible")
	$Timer.start()  # Iniciar el temporizador para reiniciar el nivel

func _on_Timer_timeout():
	# Ocultar el DeathLabel antes de recargar la escena
	if death_label:
		death_label.visible = false
		print("DeathLabel oculto, recargando escena")
	get_tree().reload_current_scene()









