class_name HealthComponent
extends Node

@export var max_hp : float
@export var health_label : Label

var health = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	display_health()
	
func set_health():
	health = max_hp
	
func damage(value: float):
	health -= value
	if health <= 0:
		get_parent().queue_free()

func display_health():
	health_label.text = "Health: " + str(health)
