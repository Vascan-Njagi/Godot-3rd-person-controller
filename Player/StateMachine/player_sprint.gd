extends State
class_name PlayerSprint

func physics_update(delta: float):
	if not player.is_on_floor():
		Transitioned.emit(self, "Air")
		return

	# --- NEW: Enable Jumping ---
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Air")
		return
	# ---------------------------

	if Input.is_action_just_released("sprint"):
		Transitioned.emit(self, "Walk")
		return

	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if input_dir.y > 0: 
		Transitioned.emit(self, "Walk")
		return

	if input_dir == Vector2.ZERO:
		Transitioned.emit(self, "Idle")
		return

	# Use player basis to fix reversed controls
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		player.velocity.x = direction.x * player.sprint_speed
		player.velocity.z = direction.z * player.sprint_speed
