extends Node3D

# --- Mouse & Look Settings ---
@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -80.0
@export var max_pitch: float = 80.0

# --- Camera Alignment Settings (NEW) ---
# "shoulder_offset" is how far to the side the camera sits.
# 0.5 = Close to head (Character blocks screen)
# 1.5 = Far to side (Center screen is clear)
@export var shoulder_offset: float = 1.5 
@export var transition_speed: float = 0.25

# --- ADS Settings ---
@export var ads_fov: float = 50.0
@export var normal_fov: float = 75.0
@export var ads_rear_length: float = 1.5    # Distance behind player when aiming
@export var normal_rear_length: float = 3.0 # Distance behind player normally
@export var ads_shoulder_offset: float = 0.8 # Tighten shoulder view when aiming? (Optional)
@export var ads_speed: float = 0.15

# --- State ---
var is_right_shoulder: bool = true

# --- References ---
@onready var edge_arm: SpringArm3D = $EdgeSpringArm
@onready var rear_arm: SpringArm3D = $EdgeSpringArm/RearSpringArm
@onready var cam_3d: Camera3D = $EdgeSpringArm/RearSpringArm/Camera3D

func _ready() -> void:
	# 1. Collision Exclusion
	var player_rid = get_parent().get_rid()
	edge_arm.add_excluded_object(player_rid)
	rear_arm.add_excluded_object(player_rid)
	
	# 2. Apply Initial Offsets
	cam_3d.fov = normal_fov
	rear_arm.spring_length = normal_rear_length
	edge_arm.spring_length = shoulder_offset # Apply the wide offset on start

func _unhandled_input(event: InputEvent) -> void:
	# --- Mouse Look ---
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var player = get_parent()
		if player:
			player.rotate_y(-event.relative.x * mouse_sensitivity)
		
		rotate_x(-event.relative.y * mouse_sensitivity)
		rotation.x = clamp(rotation.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

	# --- Shoulder Swap (Tab) ---
	if event.is_action_pressed("swap_camera_alignment"):
		switch_shoulder()

	# --- ADS Logic (Right Click) ---
	if event.is_action_pressed("ads"):
		toggle_ads(true)
	elif event.is_action_released("ads"):
		toggle_ads(false)

func toggle_ads(is_aiming: bool) -> void:
	# Determine target values
	var target_fov = ads_fov if is_aiming else normal_fov
	var target_rear_len = ads_rear_length if is_aiming else normal_rear_length
	
	# Dynamic Shoulder Offset: 
	# When aiming, we usually want the camera tighter to the head (0.8)
	# When walking, we want it wide (1.5) to see the environment.
	var target_edge_len = ads_shoulder_offset if is_aiming else shoulder_offset
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(cam_3d, "fov", target_fov, ads_speed)
	tween.tween_property(rear_arm, "spring_length", target_rear_len, ads_speed)
	tween.tween_property(edge_arm, "spring_length", target_edge_len, ads_speed)

func switch_shoulder() -> void:
	is_right_shoulder = not is_right_shoulder
	
	var edge_target_rot: float
	var rear_target_rot: float
	
	if is_right_shoulder:
		edge_target_rot = deg_to_rad(-90)
		rear_target_rot = deg_to_rad(90)
	else:
		edge_target_rot = deg_to_rad(90)
		rear_target_rot = deg_to_rad(-90)

	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(edge_arm, "rotation:y", edge_target_rot, transition_speed)
	tween.tween_property(rear_arm, "rotation:y", rear_target_rot, transition_speed)
