extends Label

func display_speed() -> void:
	self.text = "Speed: " + str(get_parent().curr_speed)
	
func _process(_delta: float) -> void:
	display_speed()
