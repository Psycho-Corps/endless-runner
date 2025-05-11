extends Node2D

@onready var area : Area2D = self.find_child('Area2D')
@onready var player : CharacterBody2D = self.find_child('Player')
@onready var obstacle_manager = self.find_child('ObstacleManager')
@onready var ground_scene : PackedScene = preload('res://endless-runner/scenes/ground.tscn')

var camera2d_left = null
var grounds : Dictionary = {}
var prev_ground : StaticBody2D = null
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
	# Get left side of screen for offscreen ground objects.
	camera2d_left = get_viewport().get_camera_2d().get_screen_center_position().x - get_viewport_rect().size.x / 2
	
	if player:
		var player_ray : RayCast2D = player.find_child('RayCast2D') if player.has_node('RayCast2D') else null
		if player_ray and player_ray.is_colliding():
			current_ground = player_ray.get_collider()
			var collision = current_ground.find_child('CollisionShape2D') if current_ground.has_node('CollisionShape2D') else null
			var end = collision.find_child('EndMarker') if collision.has_node('EndMarker') else null
			grounds[current_ground] = {
				"pos": current_ground.global_position.x,
				"end": end,
				"collision": collision
			}
			ground_collision = current_ground.find_child('CollisionShape2D')
			area.global_position = Vector2(current_ground.find_child('Marker2D').global_position.x, player.global_position.y)
		
		# Remove ground that go off screen (to the left)
		clean_ground()
		
func spawn_ground() -> void:
	var new_ground = ground_scene.instantiate()
	new_ground.global_position.x = ground_collision.global_position.x + ground_collision.shape.size.x / 2
	new_ground.global_position.y = ground_collision.global_position.y
	self.call_deferred('add_child', new_ground)
	
	obstacle_manager.spawn_obstacle(current_ground, grounds)

func clean_ground() -> void:
	for ground in grounds:
		if grounds[ground]['pos'] < player.global_position.x and current_ground != ground:
			if grounds[ground]['end'].global_position.x < camera2d_left - 100:
				print("Ground: " + str(ground) + " deleted")
				ground.queue_free()
				grounds.erase(ground)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	spawn_ground()
