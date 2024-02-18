extends Unit_class

var speed = 0
const maxSpeed = 12000
var screenSize

var direction = Vector2i()

var type
var grid

# Called when the node enters the scene tree for the first time.
func _ready():
	screenSize = get_viewport_rect().size
	grid = get_parent()
	type = grid.faction.ALLY
	init_stats(1,2,3,4,5,6,type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var inputDirection= Vector2(
#		Input.get_action_strength("right") - Input.get_action_strength("left"),
#		Input.get_action_strength("down") - Input.get_action_strength("up"))
#
#	velocity = inputDirection * speed
#	move_and_slide()
#
#	if velocity.length() > 0:
#		$AnimatedSprite2D.play()
#	else:
#		$AnimatedSprite2D.stop()
	var isMoving = Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left")
	
	direction = Vector2i()
	if isMoving:
		speed = maxSpeed
		
		if Input.is_action_pressed("up"):
			direction.y = -1
		elif Input.is_action_pressed("down"):
			direction.y = 1
		if Input.is_action_pressed("left"):
			direction.x = -1
		elif Input.is_action_pressed("right"):
			direction.x = 1
	else:
		speed = 0
	
	var target_pos = grid.update_unit_pos(self)
	position = target_pos
	
	var directionFloat = Vector2(direction)
	
	velocity = speed * directionFloat.normalized() * delta
	move_and_slide()
	

func ability1():
	# Trigger first skill when in range
	pass

func ability2():
	# Trigger second skill when in range
	pass

func interact():
	# Interact with environmental objects
	pass
	
	
#	extends Unit_class
#
#var speed = 0
#const maxSpeed = 16400
#
#var screenSize
#var direction = Vector2()
#
#const UP = Vector2(0, -1)
#const RIGHT = Vector2(1, 0)
#const DOWN = Vector2(0, 1)
#const LEFT = Vector2(-1, 0)
#
#enum faction {
#	ALLY,
#	ENEMY
#}
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	screenSize = get_viewport_rect().size
#	init_stats(1,2,3,4,5,6,faction.ALLY)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var isMoving = Input.is_action_pressed("up") or Input.is_action_pressed("right") or Input.is_action_pressed("down") or Input.is_action_pressed("left")
#
#
#	if isMoving:
#		speed = maxSpeed
#		if Input.is_action_pressed("up"):
#			direction = UP
#		elif Input.is_action_pressed("right"):
#			direction = RIGHT
#		elif Input.is_action_pressed("down"):
#			direction = DOWN
#		elif Input.is_action_pressed("left"):
#			direction = LEFT
#	else:
#		speed = 0
#
#
#	velocity = speed * direction * delta
#
#	move_and_slide()
#
##	if velocity.length() > 0:
##		$AnimatedSprite2D.play()
##	else:
##		$AnimatedSprite2D.stop()
#
#func test_call():
#	print("HELLO WORLD")
#
#func ability1():
#	# Trigger first skill when in range
#	pass
#
#func ability2():
#	# Trigger second skill when in range
#	pass
#
#func interact():
#	# Interact with environmental objects
#	pass
#
