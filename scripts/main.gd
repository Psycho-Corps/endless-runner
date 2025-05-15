extends Node2D

@onready var area : Area2D = self.find_child('Area2D')
@onready var player : CharacterBody2D = self.find_child('Player')
@onready var obstacle_manager : ObstacleManager = self.find_child('ObstacleManager')
@onready var ground_manager : GroundManager = self.find_child('GroundManager')

var camera2d_left = null
var camera2d_right = null

func _ready() -> void:
	if player:
		var health_component : HealthComponent = player.find_child('HealthComponent') if player.has_node('HealthComponent') else null
		if health_component:
			health_component.set_health()

func _process(delta: float) -> void:
	if player:
		# Get left side of screen for offscreen ground objects.
		camera2d_left = get_viewport().get_camera_2d().get_screen_center_position().x - get_viewport_rect().size.x / 2
		camera2d_right = get_viewport().get_camera_2d().get_screen_center_position().x + get_viewport_rect().size.x / 2
		
		ground_manager.set_current(player, area)
		
		# Remove ground that go off screen (to the left)
		ground_manager.clean_ground(player, camera2d_left)
	else:
		print('Game Over')
		get_tree().quit()
	
func _on_area_2d_body_entered(_body: Node2D) -> void:
	ground_manager.spawn_ground(player, obstacle_manager)
