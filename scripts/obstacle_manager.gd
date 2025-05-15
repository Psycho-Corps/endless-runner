class_name ObstacleManager
extends Node2D

var obstacles : Dictionary = {
	"wall": {"weight": 4, "type": 'ground', "scene": preload("res://endless-runner/scenes/wall.tscn")},
	"spike": {"weight": 4, "type": 'ground', "scene": preload("res://endless-runner/scenes/spike.tscn")},
	"floating_spike": {"weight": 2, "type": 'air', "scene": preload("res://endless-runner/scenes/floating_spike.tscn")}
}

var obstacle_list : Array = []
var prev_obstacle = null
var curr_obstacle = null

func random_obstacle() -> Array:
	var total_weight : int = 0
	for obstacle in obstacles:
		total_weight += obstacles[obstacle]['weight']
	var rand = randi() % total_weight
	
	var running_total : int = 0
	for obstacle in obstacles:
		running_total += obstacles[obstacle]['weight']
		if rand < running_total:
			return [obstacles[obstacle]['scene'], obstacles[obstacle]['type']]
	
	return []

func spawn_obstacle(new_ground : StaticBody2D, grounds : Dictionary, player : CharacterBody2D) -> void:
	var spawn_point : Vector2
	var distance_from_player : float = player.curr_speed * 1.5
	var ground_position = grounds[new_ground]['collision'].global_position.y
	var ground_size = grounds[new_ground]['collision'].shape.size.y / 2
	
	for i in range(10):
		var obstacle_data : Array = random_obstacle()
		var obstacle = obstacle_data[0].instantiate()
		var obstacle_type : String = obstacle_data[1]
		
		if obstacle_list.is_empty():
			curr_obstacle = obstacle
			obstacle_list.append(curr_obstacle)
			if obstacle_type == 'ground':
				spawn_point = Vector2(get_parent().camera2d_right + 50, ground_position - ground_size)
			elif obstacle_type == 'air':
				spawn_point = Vector2(get_parent().camera2d_right + 50, ground_position - 100)
			curr_obstacle.global_position = spawn_point
			get_parent().call_deferred('add_child', curr_obstacle)
			continue
		prev_obstacle = curr_obstacle
		curr_obstacle = obstacle
		obstacle_list.append(curr_obstacle)
		if obstacle_type == 'ground':
			spawn_point = Vector2(prev_obstacle.global_position.x + distance_from_player, ground_position - ground_size)
		elif obstacle_type == 'air':
			spawn_point = Vector2(prev_obstacle.global_position.x + distance_from_player, ground_position - 100)
		curr_obstacle.global_position = spawn_point
		get_parent().call_deferred('add_child', curr_obstacle)
