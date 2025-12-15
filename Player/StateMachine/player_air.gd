extends State
class_name PlayerAir

func enter():
	# If we pressed jump to get here, launch upwards
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = player.jump_velocity

func physics_update(delta: float):
	player.velocity.y -= player.gravity * delta

	if player.is_on_floor():
		# Landing logic: If moving, go to Walk, otherwise Idle
		if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
			if Input.is_action_pressed("sprint"):
				Transitioned.emit(self, "Sprint")
			else:
				Transitioned.emit(self, "Walk")
		else:
			Transitioned.emit(self, "Idle")
		return

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Check if we should use sprint speed in the air
	var current_speed = player.walk_speed
	if Input.is_action_pressed("sprint"):
		current_speed = player.sprint_speed
	
	if direction:
		player.velocity.x = move_toward(player.velocity.x, direction.x * current_speed, 0.5)
		player.velocity.z = move_toward(player.velocity.z, direction.z * current_speed, 0.5)
