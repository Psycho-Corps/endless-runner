extends Node2D

var obstacles : Dictionary = {
	"wall": {"weight": 2, "type": 'ground', "scene": preload("res://endless-runner/scenes/wall.tscn")},
	"spike": {"weight": 2, "type": 'ground', "scene": preload("res://endless-runner/scenes/spike.tscn")}
}

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

func spawn_obstacle(current_ground : StaticBody2D, grounds : Dictionary) -> void:
	var obstacle_data : Array = random_obstacle()
	var obstacle : StaticBody2D = obstacle_data[0].instantiate()
	var obstacle_type : String = obstacle_data[1]
	
	obstacle.global_position = Vector2(400, current_ground.global_position.y - grounds[current_ground]['collision'].shape.size.y)
	if obstacle_type == 'ground':
		print(obstacle.name)
		
	get_parent().call_deferred('add_child', obstacle)
