extends Node

var current_level = 1
var entrance_pos = Vector2(0, 0)
var exit_pos = Vector2(0, 0)
var tiles = null
var black_market_generated = false
var shop_type = ""
var character_index = 0
var wanted = 0

func set_tile(x, y, type):
	if tiles[x][y] != null: tiles[x][y][1].queue_free()
	
	tiles[x][y] = []

	if type != "":
		tiles[x][y].append(type)
		tiles[x][y].append(null)
	else:
		tiles[x][y] = null
		return false

	var tile
	
	if load("res://Scenes/Tiles/" + type + ".tscn"): tile = load("res://Scenes/Tiles/" + type + ".tscn").instance()
	else: tile = load("res://Scenes/Tiles/Brick.tscn").instance()
		
	tile.position = Vector2(x * 16, y * 16)
	get_node("/root/Level/CanvasLayer/TileHolder").add_child(tile)

	tiles[x][y][1] = tile
	
	return tile

func get_tile_type(x, y):
	if tiles[x][y] == null: return ""
	return tiles[x][y][0]

func get_tile(x, y):
	if tiles[x][y] == null: return false
	return tiles[x][y][1]

func reset_tiles(width, height):
	if tiles != null:
		for x in tiles:
			for tile in x:
				if tile != null: tile[1].queue_free()
	
	tiles = []
	for x in range(width):
		tiles.append([])
		for y in range(height):
			tiles[x].append(null)
