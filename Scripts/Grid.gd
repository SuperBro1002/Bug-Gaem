extends TileMap

@onready var gridLengthX = get_used_rect().size.x
@onready var gridLengthY = get_used_rect().size.y
var oppFac
var directions = [Vector2.UP,Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT]

func _ready():
	SignalBus.connect("updateGrid", update_grid_collision)
	AutoloadMe.initialize_grid(gridLengthX, gridLengthY)
	print("GRID X: ", gridLengthX)

func update_grid_collision():
	AutoloadMe.movementGrid.update()
	for x in gridLengthX:
		for y in gridLengthY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.movementGrid.set_point_solid(tilePos)
			
			# Looks thru the unitList, determines if the 
			for i in AutoloadMe.globalUnitList.size():
				match[local_to_map(AutoloadMe.globalUnitList[i].position) == tilePos, AutoloadMe.isAllyTurn, AutoloadMe.globalUnitList[i].get_faction() == 1]:
					[true,true,true]:
						AutoloadMe.movementGrid.set_point_solid(tilePos)

func set_enemy_collision():
	AutoloadMe.movementGrid.update()
	for x in gridLengthX:
		for y in gridLengthY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.movementGrid.set_point_solid(tilePos)
			
			for i in AutoloadMe.globalEnemyList.size():
				if local_to_map(AutoloadMe.globalEnemyList[i].position) == tilePos and AutoloadMe.globalEnemyList[i] != AutoloadMe.turnPointer:
					AutoloadMe.movementGrid.set_point_solid(tilePos)

func set_enemies_solid():
	AutoloadMe.movementGrid.update()
	for x in gridLengthX:
		for y in gridLengthY:
			var tilePos = Vector2i(x,y)
			
			var tileData = get_cell_tile_data(0, tilePos)
			
			if tileData == null or tileData.get_custom_data("walkable") == false:
				AutoloadMe.movementGrid.set_point_solid(tilePos)
			
			# Looks thru the unitList, determines if the 
			for i in AutoloadMe.globalUnitList.size():
				match[local_to_map(AutoloadMe.globalUnitList[i].position) == tilePos, AutoloadMe.globalUnitList[i].get_faction() == 1]:
					[true,true]:
						AutoloadMe.movementGrid.set_point_solid(tilePos)

func convert_to_map(localPos):
	return local_to_map(localPos)

func is_in_bounds(point):
	if point.x < 0 or point.x > gridLengthX:
		return false
	if point.y < 0 or point.y >gridLengthY:
		return false
	return true

func is_occupied_by_ally(pos):
	#print(AutoloadMe.globalAllyList)
	for i in AutoloadMe.globalAllyList.size():
		#print(pos, " ", local_to_map(AutoloadMe.globalAllyList[i].position))
		if Vector2i(pos) == local_to_map(AutoloadMe.globalAllyList[i].position):
			#print("ALLY already occupying this space")
			return true
	return false

func is_tile_open(pos):
	if !AutoloadMe.movementGrid.is_point_solid(local_to_map(pos)) and !is_occupied_by_ally(local_to_map(pos)):
		return true
	else:
		return false

func flood_fill_movement(start, maxDistance):
	var validTiles = []
	var searchStack = [local_to_map(start)]
	
	while !searchStack.is_empty():
		var current = searchStack.pop_back()
		
		if !is_in_bounds(current):
			continue
		if current in validTiles:
			continue
		if AutoloadMe.movementGrid.is_point_solid(current):
			continue
		
		var pathArray = AutoloadMe.movementGrid.get_point_path(local_to_map(start),current)
		var distance = pathArray.size() - 1
		if distance > maxDistance:
			continue
		
		validTiles.append(current)
		
		for i in directions:
			var coords = Vector2(Vector2i(current) + Vector2i(i))
			if AutoloadMe.movementGrid.is_point_solid(coords):
				continue
			if coords in validTiles:
				continue
			
			searchStack.append(coords)
	
	for i in validTiles.size():
		validTiles[i] = map_to_local(validTiles[i])
	return validTiles

func flood_fill_first(start):
	set_enemies_solid()
	var searchedTiles = []
	var searchStack = [start]
	var firstValid = Vector2i(-1,-1)
	
	print("8,8 IS SOLID? ", AutoloadMe.movementGrid.is_point_solid(Vector2(8,8)))
	while !searchStack.is_empty():
		var current = searchStack.pop_front()
		for i in directions:
			searchStack.append(Vector2(Vector2i(current) + Vector2i(i)))
		
		if !is_in_bounds(current):
			continue
		if current in searchedTiles:
			continue
		if is_occupied_by_ally(current):
			print("Occupied by ally!")
			continue
		if !AutoloadMe.movementGrid.is_point_solid(current):
			print("FOUND A VALID POINT")
			return map_to_local(current)
		
		searchedTiles.append(current)
		
		for i in directions:
			var coords = Vector2(Vector2i(current) + Vector2i(i))
			
			if !is_in_bounds(coords):
				continue
			if AutoloadMe.movementGrid.is_point_solid(coords):
				continue
			if coords in searchedTiles:
				continue
			
			searchStack.append(coords)
	
	return map_to_local(firstValid)
