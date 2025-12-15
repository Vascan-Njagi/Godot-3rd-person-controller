class_name State
extends Node

# Reference to the player so states can move him
var player: CharacterBody3D

# Signals to tell the machine to switch states
signal Transitioned(state, new_state_name)

func enter():
	pass

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass
