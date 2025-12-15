class_name Player # Global class name for easy access
extends CharacterBody3D

# --- Movement Stats ---
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var crouch_speed: float = 2.5
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8

@onready var camera_pivot: Node3D = $Camera

func _ready() -> void:
	# CRITICAL: We must capture the mouse, or the camera script will ignore input!
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	# Add this back so you can press ESC to get your cursor back
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
# --- Weapon State (For animations later) ---
enum Weapon { NONE, AXE, GUN }
var current_weapon = Weapon.AXE 
