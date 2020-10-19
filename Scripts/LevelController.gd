extends Node

onready var globals = get_node("/root/Globals")

var first_room = 0
var last_room = 0
var rooms = [
	[4, 4, 4, 4],
	[4, 4, 4, 4],
	[4, 4, 4, 4],
	[4, 4, 4, 4]
]

var has_altar = false
var has_idol = false
var has_damsel = false
var has_shop = false

func generate_border():
	for x in range(42):
		for y in range(34):
			if x == 0 or x == 41 or y == 0 or y == 33: globals.set_tile(x, y, "Brick")

const HORIZONTAL_PATH_ENTRANCE = 0
const HORIZONTAL_PATH_DROP_ENTRANCE = 1
const HORIZONTAL_PATH_EXIT = 2
const HORIZONTAL_PATH_DROP_EXIT = 3
const RANDOM_ROOM = 4
const HORIZONTAL_PATH = 5
const HORIZONTAL_PATH_DROP = 6
const HORIZONTAL_PATH_OPEN_CEILING = 7
const SHOP_LEFT = 8
const SHOP_RIGHT = 9
const SNAKE_PIT_TOP = 10
const SNAKE_PIT_MID = 11
const SNAKE_PIT_BOTTOM = 12
const DROP = 13
const IDOL = 14
const ALTAR = 15

var room_templates = {
	HORIZONTAL_PATH_ENTRANCE: [
		"60000600000000000000000000000000000000000008000000000000000000000000001111111111",
		"11111111112222222222000000000000000000000008000000000000000000000000001111111111",
		"00000000000008000000000000000000L000000000P111111000L111111000L00111111111111111",
		"0000000000008000000000000000000000000L000111111P000111111L001111100L001111111111"
	],
	HORIZONTAL_PATH_DROP_ENTRANCE: [
		"60000600000000000000000000000000000000000008000000000000000000000000002021111120",
		"11111111112222222222000000000000000000000008000000000000000000000000002021111120",
		"00000000000008000000000000000000L000000000P111111000L111111000L00011111111101111",
		"0000000000008000000000000000000000000L000111111P000111111L001111000L001111011111"
	],
	HORIZONTAL_PATH_EXIT: [
		"60000600000000000000000000000000000000000008000000000000000000000000001111111111",
		"11111111112222222222000000000000000000000008000000000000000000000000001111111111"
	],
	HORIZONTAL_PATH_DROP_EXIT: [
		"00000000006000060000000000000000000000000008000000000000000000000000001111111111",
		"00000000000000000000000000000000000000000008000000000000000000000000001111111111",
		"00000000000010021110001001111000110111129012000000111111111021111111201111111111",
		"00000000000111200100011110010021111011000000002109011111111102111111121111111111"
	],
	RANDOM_ROOM: [
		"110000000040L600000011P000000011L000000011L5000000110000000011000000001111111111",
		"00000000110060000L040000000P110000000L110050000L11000000001100000000111111111111",
		"110000000040L600000011P000000011L000000011L0000000110000000011000000001112222111",
		"00000000110060000L040000000P110000000L110000000L11000000001100000000111112222111",
		"11111111110221111220002111120000022220000002222000002111120002211112201111111111",
		"11111111111112222111112000021111102201111120000211111022011111200002111112222111",
		"11111111110000000000110000001111222222111111111111112222221122000000221100000011",
		"121111112100L2112L0011P1111P1111L2112L1111L1111L1111L1221L1100L0000L001111221111"
	],
	HORIZONTAL_PATH: [
		"60000600000000000000000000000000000000000050000000000000000000000000001111111111",
		"60000600000000000000000000000000000000005000050000000000000000000000001111111111",
		"60000600000000000000000000000000050000000000000000000000000011111111111111111111",
		"60000600000000000000000600000000000000000000000000000222220000111111001111111111",
		"11111111112222222222000000000000000000000050000000000000000000000000001111111111",
		"11111111112111111112022222222000000000000050000000000000000000000000001111111111",
		"11111111112111111112211111111221111111120111111110022222222000000000001111111111",
		"1111111111000000000L111111111P000000000L5000050000000000000000000000001111111111",
		"000000000000L0000L0000P1111P0000L0000L0000P1111P0000L1111L0000L1111L001111111111",
		"00000000000111111110001111110000000000005000050000000000000000000000001111111111",
		"00000000000000000000000000000000000000000021111200021111112021111111121111111111",
		"2222222222000000000000000000L001111111P001050000L011000000L010000000L01111111111"
	],
	HORIZONTAL_PATH_DROP: [
		"00000000006000060000000000000000000000006000060000000000000000000000000000000000",
		"00000000006000060000000000000000000000000000050000000000000000000000001202111111",
		"00000000006000060000000000000000000000050000000000000000000000000000001111112021",
		"00000000006000060000000000000000000000000000000000000000000002200002201112002111",
		"00000000000000220000000000000000200002000112002110011100111012000000211111001111",
		"00000000000060000000000000000000000000000000000000001112220002100000001110111111",
		"00000000000060000000000000000000000000000000000000002221110000000001201111110111",
		"00000000000060000000000000000000000000000000000000002022020000100001001111001111",
		"11111111112222222222000000000000000000000000000000000000000000000000001120000211",
		"11111111112222111111000002211100000002110000000000200000000000000000211120000211",
		"11111111111111112222111220000011200000000000000000000000000012000000001120000211",
		"11111111112111111112021111112000211112000002112000000022000002200002201111001111"
	],
	HORIZONTAL_PATH_OPEN_CEILING: [
		"00000000006000060000000000000000000000006000060000000000000000000000000000000000",
		"00000000006000060000000000000000000000000000050000000000000000000000001202111111",
		"00000000006000060000000000000000000000050000000000000000000000000000001111112021",
		"00000000006000060000000000000000000000000000000000000000000002200002201112002111",
		"00000000000000220000000000000000200002000112002110011100111012000000211111001111",
		"00000000000060000000000000000000000000000000000000001112220002100000001110111111",
		"00000000000060000000000000000000000000000000000000002221110000000001201111110111",
		"00000000000060000000000000000000000000000000000000002022020000100001001111001111"
	],
	DROP: [
		"00000000006000060000000000000000000000006000060000000000000000000000000000000000",
		"00000000006000060000000000000000000000000000050000000000000000000000001202111111",
		"00000000006000060000000000000000000000050000000000000000000000000000001111112021",
		"00000000006000060000000000000000000000000000000000000000000002200002201112002111",
		"00000000000000220000000000000000200002000112002110011100111012000000211111001111",
		"00000000000060000000000000000000000000000000000000001112220002100000001110111111",
		"00000000000060000000000000000000000000000000000000002221110000000001201111110111",
		"00000000000060000000000000000000000000000000000000002022020000100001001111001111"
	],
	SHOP_LEFT: [
		"111111111111111111111111221111111l000211...000W010...00000k0..Kiiii000bbbbbbbbbb",
		"11111111111111111111111122111111Kl000211..bQ00W010.0+00000k0.q+dd00000bbbbbbbbbb",
		"111111111111111111111111221111111l000211...000W010...00000k0..K00D0000bbbbbbbbbb"
	],
	SHOP_RIGHT: [
		"111111111111111111111111221111112000l11101W0000...0k00000...000iiiiK..bbbbbbbbbb",
		"111111111111111111111111221111112000lK1101W0Q00b..0k00000+0.00000dd+q.bbbbbbbbbb",
		"111111111111111111111111221111112000l11101W0000...0k00000...0000D00K..bbbbbbbbbb"
	],
	SNAKE_PIT_TOP: [
		"00000000006000060000000000000000000000000000000000000000000002200002201112002111",
		"00000000000000220000000000000000200002000112002110011100111012000000211111001111",
		"00000000000060000000000000000000000000000000000000001112220002100000001110111111",
		"00000000000060000000000000000000000000000000000000002221110000000001201111110111",
		"00000000000060000000000000000000000000000000000000002022020000100001001111001111",
		"11111111112222222222000000000000000000000000000000000000000000000000001120000211",
		"11111111112222111111000002211100000002110000000000200000000000000000211120000211",
		"11111111111111112222111220000011200000000000000000000000000012000000001120000211",
		"11111111112111111112021111112000211112000002112000000022000002200002201111001111"
	],
	SNAKE_PIT_MID: [
		"111000011111s0000s11111200211111s0000s11111200211111s0000s11111200211111s0000s11"
	],
	SNAKE_PIT_BOTTOM: [
		"111000011111s0000s1111100001111100S0001111S0110S11111STTS1111111M111111111111111"
	],
	IDOL: [
		"22000000220000B0000000000000000000000000000000000000000000000000I000001111A01111"
	],
	ALTAR: [
		"220000002200000000000000000000000000000000000000000000x0000002211112201111111111"
	],
}

var obstacle_templates = {
	"5": ["111110000000000",
		"000001111000000",
		"000000111100000",
		"000000000011111",
		"000002020017177",
		"000000202071717",
		"000000020277171",
		"000002220011100",
		"000000222001110",
		"000000022200111",
		"111002220000000",
		"011100222000000",
		"001110022200000",
		"000000222021112",
		"000002010077117",
		"000000010271177"],
	"6": ["111110000000000",
		"222220000000000",
		"111002220000000",
		"011100222000000",
		"001110022200000",
		"000000111000000",
		"000000111002220",
		"000000222001110",
		"000000022001111",
		"000002220011100"],
	"8": ["009000111011111",
		"009000212002120",
		"000000000092222",
		"000000000022229",
		"000001100119001",
		"000001001110091",
		"111111000140094",
		"000001202112921"]
}

func generate_room(current_room, current_layer, current_level, type):
	var room = room_templates[type][randi() % room_templates[type].size()]
	var obstacle = "000000000000000"

	if type == RANDOM_ROOM:
		if current_level > 0 and not has_altar and randi() % 16 == 0:
			room = room_templates[ALTAR][randi() % room_templates[ALTAR].size()]
			has_altar = true
		elif not has_idol and not current_layer == 3 and randi() % 10 == 0:
			room = room_templates[IDOL][randi() % room_templates[IDOL].size()]
			has_idol = true
		if room == "0000000000000000000000000000L001111111P001050000L011000000L010000000L01111111111" and randi() % 2 == 0:
			room = "000000000000000000000L000000000P111111100L500000100L000000110L000000011111111111"
	elif type == HORIZONTAL_PATH:
		if room == "1111111111000000000L111111111P000000000L5000050000000000000000000000001111111111" and randi() % 2 == 0:
			room = "1111111111L000000000P111111111L0000000005000050000000000000000000000001111111111"
		if room == "2222222222000000000000000000L001111111P001050000L011000000L010000000L01111111111" and randi() % 2 == 0:
			room = "222222222200000000000L000000000P111111100L500000100L000000110L000000011111111111"
	elif type == SHOP_LEFT:
		room = room_templates[8][0]
		match randi() % 7:
			0: globals.shop_type = "General"
			1: globals.shop_type = "Bomb"
			2: globals.shop_type = "Weapon"
			3: globals.shop_type = "Rare"
			4: globals.shop_type = "Clothing"
			5:
				globals.shop_type = "Craps"
				room = room_templates[8][1]
			6:
				globals.shop_type = "Kissing"
				room = room_templates[8][2]
				has_damsel = true
	elif type == SHOP_RIGHT:
		room = room_templates[9][0]
		match randi() % 7:
			0: globals.shop_type = "General"
			1: globals.shop_type = "Bomb"
			2: globals.shop_type = "Weapon"
			3: globals.shop_type = "Rare"
			4: globals.shop_type = "Clothing"
			5:
				globals.shop_type = "Craps"
				room = room_templates[9][1]
			6:
				globals.shop_type = "Kissing"
				room = room_templates[9][2]
				has_damsel = true

	# Add obstacles
	for i in range(1, 80):
		var j = i
		var tile_type = room.substr(i, 1)

		if tile_type == "5" or tile_type == "6" or tile_type == "8":
			obstacle = obstacle_templates[tile_type][randi() % obstacle_templates[tile_type].size()]
			room.erase(j, 5)
			room = room.insert(j, obstacle.substr(0, 5))
			j += 10
			room.erase(j, 5)
			room = room.insert(j, obstacle.substr(5, 5))
			j += 10
			room.erase(j, 5)
			room = room.insert(j, obstacle.substr(10, 5))

	# Generate the tiles
	for j in range(8):
		for i in range(10):
			var tile_type = room.substr(i + j * 10, 1)
			var x = i + current_room * 10 + 1
			var y = j + current_layer * 8 + 1
			
			if tile_type == "1":
				if randi() % 10 == 0: globals.set_tile(x, y, "Block")
				else: globals.set_tile(x, y, "Brick")
			elif tile_type == "2" and randi() % 2 == 0:
				if randi() % 10 == 0: globals.set_tile(x, y, "Block")
				else: globals.set_tile(x, y, "Brick")
			elif tile_type == "L": globals.set_tile(x, y, "Ladder")
			elif tile_type == "P": globals.set_tile(x, y, "LadderTop")
			elif tile_type == "7" and randi() % 3 == 0: globals.set_tile(x, y, "Spikes")
			elif tile_type == "4" and randi() % 4 == 0: globals.set_tile(x, y, "Block") #instance_create(xpos, ypos, oPushBlock)
			elif tile_type == "9":
				var below = globals.set_tile(x, y + 1, "Brick")
				if type == 0 or type == 1:
					globals.set_tile(x, y, "Entrance")
					find_node("Player").position = Vector2(x * 16 + 8, y * 16 + 8)
					globals.entrance_pos = Vector2(x, y)
				else:
					globals.set_tile(x, y, "Exit")
					globals.exit_pos = Vector2(x, y)
					below.invincible = true
			elif tile_type == "A":
				globals.set_tile(x, y, "IdolAltar")
				globals.set_tile(x + 1, y, "IdolAltar")
			elif tile_type == "x":
				globals.set_tile(x, y, "SacAltar")
				globals.set_tile(x + 1, y, "SacAltar")
				var statue = load("res://Scenes/KaliStatue.tscn").instance()
				statue.position = Vector2(x * 16, y * 16)
				add_child(statue)
			#elif tile_type == "I":
			#	instance_create(xpos+16, ypos+12, oGoldIdol)
			elif tile_type == "B":
				var statue = load("res://Scenes/TikiStatue.tscn").instance()
				statue.position = Vector2(x * 16, y * 16)
				add_child(statue)
			elif tile_type == "Q" and globals.shop_type == "Craps":
				var dice_sign = Sprite.new()
				dice_sign.texture = load("res://Sprites/DiceSign.png")
				dice_sign.centered = false
				dice_sign.position = Vector2(x * 16, y * 16)
				add_child(dice_sign)
			#elif tile_type == "q":
			#	n = randi() % 6 + 1
			#	scrGenerateItem(xpos+8, ypos+8, 1)
			#	obj.inDiceHouse = true
			elif tile_type == "+": # This is poorly handled. When ice blocks are implemented, replace it
				var tile = globals.set_tile(x, y, "Block")
				var ice = AtlasTexture.new()
				ice.atlas = load("res://Sprites/Caves.png")
				ice.region = Rect2(Vector2(432, 0), Vector2(16, 16))
				tile.get_node("Sprite").texture = ice
				tile.shop_wall = true
			elif tile_type == "W" and globals.wanted > 0:
				var wanted_texture = AtlasTexture.new()
				wanted_texture.atlas = load("res://Sprites/Wanted.png")
				wanted_texture.region = Rect2(Vector2(globals.character_index * 16, 0), Vector2(32, 32))
				var wanted_sign = Sprite.new()
				wanted_sign.centered = false
				wanted_sign.position = Vector2(x * 16, y * 16)
				wanted_sign.texture = wanted_texture
				add_child(wanted_sign)
			elif tile_type == ".": # and not collision_point(xpos, ypos, oSolid, 0, 0):
				var wall
				if randi() % 10 == 0: wall = globals.set_tile(x, y, "Block")
				else: wall = globals.set_tile(x, y, "Brick")
				wall.shop_wall = true
			elif tile_type == "b":
				var shop_floor = globals.set_tile(x, y, "ShopFloor")
				shop_floor.shop_wall = true
			#elif tile_type == "l":
			#	if has_damsel: instance_create(xpos, ypos, oLampRed)
			#	else: instance_create(xpos, ypos, oLamp)
			#elif tile_type == "K":
			#	obj = instance_create(xpos, ypos, oShopkeeper)
			#	obj.style = globals.shop_type
			elif tile_type == "k":
				var shop_sign = globals.set_tile(x, y, "Sign")
				#shop_sign.set_type(globals.shop_type)
			#elif tile_type == "i": scrShopItemsGen()
			#elif tile_type == "d": instance_create(xpos+8, ypos+8, oDice)
			#elif tile_type == "D":
			#	obj = instance_create(xpos+8, ypos+8, oDamsel)
			#	obj.forSale = true
			#	obj.status = 5
			elif tile_type == "s":
				if randi() % 10 == 0: pass #instance_create(xpos, ypos, oSnake)
				elif randi() % 2 == 0: globals.set_tile(x, y, "Brick")
			#elif tile_type == "S": instance_create(xpos, ypos, oSnake)
			#elif tile_type == "T": instance_create(xpos+8, ypos+8, oRubyBig)
			elif tile_type == "M":
				globals.set_tile(x, y, "Brick")
			#	obj = instance_create(xpos+8, ypos+8, oMattock)
			#	obj.cost = 0
			#	obj.forSale = false
	
	return [has_altar, has_idol, has_damsel]

func generate_level():
	generate_border()
	
	first_room = randi() % 4
	var current_room = first_room
	var current_layer = 0
	var finished = false
	
	rooms[current_room][current_layer] = 0
	
	while !finished:
		var old_room = current_room
		var old_layer = current_layer
		var change = randi() % 5 + 1

		if change == 1 or change == 2: current_room += 1
		elif change == 3 or change == 4: current_room -= 1
		else: current_layer += 1
		
		if current_room == -1 or current_room == 4:
			current_room = old_room
			current_layer += 1
		
		if current_layer == 4:
			finished = true
			last_room = current_room
			rooms[current_room][old_layer] = HORIZONTAL_PATH_EXIT
			if (rooms[current_room][old_layer - 1] > 4 and rooms[current_room][old_layer - 1] < 8) or rooms[current_room][old_layer - 1] == DROP:
				rooms[current_room][old_layer] = HORIZONTAL_PATH_DROP_EXIT
		elif current_layer != old_layer:
			rooms[current_room][current_layer] = HORIZONTAL_PATH_OPEN_CEILING
			if rooms[current_room][old_layer] == HORIZONTAL_PATH_ENTRANCE: rooms[current_room][old_layer] = HORIZONTAL_PATH_DROP_ENTRANCE
			if rooms[current_room][old_layer] == HORIZONTAL_PATH: rooms[current_room][old_layer] = HORIZONTAL_PATH_DROP
			if rooms[current_room][old_layer] == HORIZONTAL_PATH_OPEN_CEILING: rooms[current_room][old_layer] = DROP
		elif rooms[current_room][current_layer] == RANDOM_ROOM:
			rooms[current_room][current_layer] = HORIZONTAL_PATH
	
	if randi() % globals.current_level <= 1 and globals.current_level > 0 and not globals.black_market_generated:
		var i = 0
		var poss = [
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		]
		for j in range(4):
			for k in range(4):
				if j < 3:
					if rooms[j + 1][k] < 8 and rooms[j + 1][k] > 4:
						poss[j][k] = SHOP_LEFT
						i += 1
				elif j > 0:
					if rooms[j - 1][k] < 8 and rooms[j - 1][k] > 4:
						poss[j][k] = SHOP_RIGHT
						i += 1
		
		if i > 0:
			var n = randi() % i
			for j in range(4):
				for k in range(4):
					if poss[j][k] != 0:
						if n == 0: rooms[j][k] = poss[j][k]
						n -= 1

	for layer in range(4):
		for room in range(4):
			generate_room(room, layer, globals.current_level, rooms[room][layer])

	#for x in range(42):
		#for y in range(34):
			#if globals.get_tile_type(x, y) == "Spikes" and globals.get_tile_type(x, y + 1) == "": globals.set_tile(x, y, "") # temporary fix
			
func _ready():
	randomize()
	globals.reset_tiles(42, 34)
	generate_level()
