extends CharacterBody2D

@onready var collision : CollisionShape2D = self.find_child('CollisionShape2D') if self.has_node('CollisionShape2D') else null

const JUMP_VELOCITY : float = -400.0
const acceleration : float = 10.0

var elapsed_time : float = 0.0
var base_speed : float = 200.0
var curr_speed : float = 0.0
var base_collision : float = 0.0

func _ready():
	base_collision = collision.shape.height
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	curr_speed = base_speed + (elapsed_time * acceleration)
	velocity.x = curr_speed

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed('crouch') and is_on_floor():
		collision.shape.height = base_collision / 2
		collision.position.y = (base_collision / 2) / 2
	elif Input.is_action_just_released('crouch'):
		collision.shape.height = base_collision
		collision.position.y = base_collision - base_collision 
		
	move_and_slide()
