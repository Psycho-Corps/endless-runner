extends Node2D

@onready var player : CharacterBody2D = self.find_child('Player')
@onready var ground_scene : PackedScene = preload('res://endless-runner/scenes/ground.tscn')

var current_ground : StaticBody2D = null
var ground_collision : CollisionShape2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if player:
		var health_component : HealthComponent = player.find_child('HealthComponent') if player.has_node('HealthComponent') else null
		if health_component:
			health_component.set_health()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		var player_ray : RayCast2D = player.find_child('RayCast2D') if player.has_node('RayCast2D') else null
		if player_ray and player_ray.is_colliding():
			current_ground = player_ray.get_collider()
			ground_collision = current_ground.find_child('CollisionShape2D')
	
	if abs(player.global_position.x - ground_collision.global_position.x) < 10:
		spawn_ground()

func spawn_ground() -> void:
	var new_ground = ground_scene.instantiate()
	new_ground.global_position.x = ground_collision.global_position.x + ground_collision.shape.size.x / 2
	self.add_child(new_ground)
