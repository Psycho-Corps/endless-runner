class_name HealthComponent
extends Node

@export var max_hp : float
var health = 0

func _ready() -> void:
	pass
	
func set_health():
	health = max_hp
	
func damage(value: float):
	pass
