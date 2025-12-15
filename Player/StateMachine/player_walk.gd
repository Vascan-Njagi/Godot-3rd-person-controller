extends State
class_name PlayerWalk

func physics_update(delta: float):
	if not player.is_on_floor():
		Transitioned.emit(self, "Air")
		return

	# --- NEW: Enable Jumping ---
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Air")
		return
	# ---------------------------

	if Input.is_action_pressed("sprint"):
		Transitioned.emit(self, "Sprint")
		return

	if Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "Crouch")
		return

	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir == Vector2.ZERO:
		Transitioned.emit(self, "Idle")
		return

	# Use player basis to fix the "Reversed Controls" bug
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.walk_speed
		player.velocity.z = direction.z * player.walk_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.walk_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.walk_speed)
