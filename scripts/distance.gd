extends Label

@onready var player : CharacterBody2D = get_parent().find_child('Player') if get_parent().has_node('Player') else null

var elapsed_time : float = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta
	if player:
		self.text = "Distance: " + str(player.curr_speed * elapsed_time)
