extends State
class_name PlayerIdle

func enter():
	# Clear velocity when entering idle
	player.velocity.x = 0
	player.velocity.z = 0

func physics_update(delta: float):
	# Fall if not on floor
	if not player.is_on_floor():
		Transitioned.emit(self, "Air")
		return

	# Jump
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "Air")
		return

	# Move
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		Transitioned.emit(self, "Walk")
		return
	
	# Crouch
	if Input.is_action_pressed("crouch"):
		Transitioned.emit(self, "Crouch")
