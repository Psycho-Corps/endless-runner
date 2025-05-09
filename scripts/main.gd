extends Node2D

@onready var player : CharacterBody2D = self.find_child('Player')
@onready var area : Area2D = self.find_child('Area2D')
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
			area.global_position = Vector2(ground_collision.global_position.x - 60, player.global_position.y)

func spawn_ground() -> void:
	var new_ground = ground_scene.instantiate()
	new_ground.global_position.x = ground_collision.global_position.x + ground_collision.shape.size.x / 2
	new_ground.global_position.y = ground_collision.global_position.y
	self.call_deferred('add_child', new_ground)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	self.call_deferred('spawn_ground')
