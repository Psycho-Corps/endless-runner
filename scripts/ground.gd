extends StaticBody2D

@export var collision : CollisionShape2D
@onready var player : CharacterBody2D = get_parent().find_child('Player') if get_parent().has_node('Player') else null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.shape.size.x = 1000
	collision.position.x += collision.shape.size.x / 2
