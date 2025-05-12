extends Node2D

var obstacles : Dictionary = {
	"wall": {"weight": 4, "type": 'ground', "scene": preload("res://endless-runner/scenes/wall.tscn")},
	"spike": {"weight": 4, "type": 'ground', "scene": preload("res://endless-runner/scenes/spike.tscn")},
	"floating_spike": {"weight": 2, "type": 'air', "scene": preload("res://endless-runner/scenes/floating_spike.tscn")}
}

func random_obstacle() -> Array:
	var total_weight : int = 0
	for obstacle in obstacles:
		if obstacles[obstacle]['type'] == "ground":
			total_weight += obstacles[obstacle]['weight']
	var rand = randi() % total_weight
	
	var running_total : int = 0
	for obstacle in obstacles:
		running_total += obstacles[obstacle]['weight']
		if rand < running_total:
			return [obstacles[obstacle]['scene'], obstacles[obstacle]['type']]
	
	return []

func spawn_obstacle(new_ground : StaticBody2D, grounds : Dictionary) -> void:
	var spawn_point : Vector2
	var prev_obstacle = null
	var curr_obstacle = null
	
	for i in range(3):
		var obstacle_data : Array = random_obstacle()
		var obstacle = obstacle_data[0].instantiate()
		var obstacle_type : String = obstacle_data[1]
		if curr_obstacle:
			prev_obstacle = curr_obstacle
			curr_obstacle = obstacle
			spawn_point = Vector2(randf_range(prev_obstacle.global_position.x + 200, prev_obstacle.global_position.x + 400), grounds[new_ground]['collision'].global_position.y - grounds[new_ground]['collision'].shape.size.y / 2)
			curr_obstacle.global_position = spawn_point
			get_parent().call_deferred('add_child', curr_obstacle)
			print(prev_obstacle)
			print(spawn_point)	
			continue
		curr_obstacle = obstacle
		spawn_point = Vector2(randf_range(grounds[new_ground]['begin'].global_position.x, grounds[new_ground]['begin'].global_position.x + 100), grounds[new_ground]['collision'].global_position.y - grounds[new_ground]['collision'].shape.size.y / 2)
		curr_obstacle.global_position = spawn_point
		get_parent().call_deferred('add_child', curr_obstacle)
