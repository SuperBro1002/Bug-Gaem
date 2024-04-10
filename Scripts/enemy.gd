extends Unit_class

var speed = 225
var screenSize

@onready var ability1 = load_ability(SetAbility1)
@onready var ability2 = load_ability(SetAbility1)
@onready var ability3 = load_ability(SetAbility1)

var animationSpeed = 4
var type = fac.ENEMY
var lengthList = []
var target
var shortestPath = 10000
@onready var astarGrid = AutoloadMe.movementGrid

func _ready():
	screenSize = get_viewport_rect().size
	#add_passive("Trap")

func unique_turn_start():
	shortestPath = 10000
	lengthList = [] # List of distances to different opposing units
	target = null
	grid.set_enemy_collision()
	
	for i in AutoloadMe.globalAllyList.size():
		end = grid.local_to_map(AutoloadMe.globalAllyList[i].position)
		lengthList.append(AutoloadMe.movementGrid.get_point_path(start, end).size())
	
	# Determines the closest unit
	for i in lengthList.size():
		if lengthList[i] < shortestPath:
			shortestPath = lengthList[i]
			target = AutoloadMe.globalAllyList[i]
	
	end = grid.local_to_map(target.position)
	
	var pathArray = AutoloadMe.movementGrid.get_point_path(start, end)
	
	if canMove == true:
		for i in pathArray.size() - 1:
			if CurrentAP != 0 and i > 0:
				CurrentAP -= 1
				var tween = create_tween()
				tween.tween_property(self, "position", pathArray[i], 1.0 / animationSpeed).set_trans(Tween.TRANS_SINE)
				await tween.finished
	
	pathArray = AutoloadMe.movementGrid.get_point_path(grid.local_to_map(position), end)
	
	while CurrentAP >= ability1.get_ap_cost() and pathArray.size() <= 2:
		ability1.targetUnits.append(target)
		ability1.execute()
		CurrentAP -= ability1.get_ap_cost()
		
		await get_tree().create_timer(1).timeout
	
	on_turn_end()
