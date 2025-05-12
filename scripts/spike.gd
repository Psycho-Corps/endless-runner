extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var health_component = body.find_child('HealthComponent') if body.has_node('HealthComponent') else null
	if health_component:
		health_component.damage(1.0)
