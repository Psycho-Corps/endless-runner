class_name GroundManager
extends Node2D

@onready var ground_scene : PackedScene = preload('res://endless-runner/scenes/ground.tscn')

var grounds : Dictionary = {}
var prev_ground : StaticBody2D = null
var current_ground : StaticBody2D = null
var ground_collision : CollisionShape2D = null

func set_current(player : CharacterBody2D, area : Area2D) -> void:
	var player_ray : RayCast2D = player.find_child('RayCast2D') if player.has_node('RayCast2D') else null
	
	current_ground = player_ray.get_collider()
	if current_ground not in grounds:
		var collision = current_ground.find_child('CollisionShape2D') if current_ground.has_node('CollisionShape2D') else null
		var end = collision.find_child('EndMarker') if collision.has_node('EndMarker') else null
		var begin = collision.find_child('BeginMarker') if collision.has_node('BeginMarker') else null
		
		grounds[current_ground] = {
			"pos": current_ground.global_position.x,
			"begin": begin,
			"end": end,
			"collision": collision
		}
		
	ground_collision = current_ground.find_child('CollisionShape2D')
	area.global_position = Vector2(current_ground.find_child('Marker2D').global_position.x, player.global_position.y)
	
func spawn_ground(player : CharacterBody2D, obstacle_manager : Node2D) -> void:
	var new_ground = ground_scene.instantiate()
	var collision = new_ground.find_child('CollisionShape2D') if new_ground.has_node('CollisionShape2D') else null
	var begin = collision.find_child('BeginMarker') if collision.has_node('BeginMarker') else null
	var end = collision.find_child('EndMarker') if collision.has_node('EndMarker') else null
	
	grounds[new_ground] = {
		"pos": new_ground.global_position.x,
		"begin": begin,
		"end": end,
		"collision": collision
	}
			
	new_ground.global_position.x = ground_collision.global_position.x + ground_collision.shape.size.x
	new_ground.global_position.y = ground_collision.global_position.y
	get_parent().call_deferred('add_child', new_ground)
	
	obstacle_manager.spawn_obstacle(new_ground, grounds, player)

func clean_ground(player : CharacterBody2D, camera2d_left : float) -> void:
	for ground in grounds:
		if grounds[ground]['pos'] < player.global_position.x and current_ground != ground:
			if grounds[ground]['end'].global_position.x < camera2d_left - 100:
				print("Ground: " + str(ground) + " deleted")
				ground.queue_free()
				grounds.erase(ground)
	
