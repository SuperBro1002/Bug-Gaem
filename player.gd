extends Unit_class

var speed = 225
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	init_stats(1,2,3,4,5,6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var inputDirection= Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up"))
		
	velocity = inputDirection * speed
	move_and_slide()
	
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass

func interact():
	# Interact with environmental objects
	pass
