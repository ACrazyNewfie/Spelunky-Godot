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
			if x == 0 or x == 41 or y == 0 or y == 33: find_node("Tiles").set_cell(x, y, 0)

const EMPTY = -1
const BRICK = 0
const BLOCK = 1
const LADDER = 2
const LADDER_TOP = 3
const SPIKES = 4
const ALTAR_LEFT = 5
const ALTAR_RIGHT = 6
const SAC_ALTAR_LEFT = 7
const SAC_ALTAR_RIGHT = 8
const ENTRANCE = 9
const EXIT = 10
const BRICK_DOWN = 11
const BRICK2 = 12
const BRICK_GOLD = 13
const BRICK_GOLD_BIG = 14

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
	var shop_type = ""

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
			0: shop_type = "General"
			1: shop_type = "Bomb"
			2: shop_type = "Weapon"
			3: shop_type = "Rare"
			4: shop_type = "Clothing"
			5:
				shop_type = "Craps"
				room = room_templates[8][1]
			6:
				shop_type = "Kissing"
				room = room_templates[8][2]
				has_damsel = true
	elif type == SHOP_RIGHT:
		room = room_templates[9][0]
		match randi() % 7:
			0: shop_type = "General"
			1: shop_type = "Bomb"
			2: shop_type = "Weapon"
			3: shop_type = "Rare"
			4: shop_type = "Clothing"
			5:
				shop_type = "Craps"
				room = room_templates[9][1]
			6:
				shop_type = "Kissing"
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
				if randi() % 10 == 0: find_node("Tiles").set_cell(x, y, BLOCK)
				else: find_node("Tiles").set_cell(x, y, BRICK)
			elif tile_type == "2" and randi() % 2 == 0:
				if randi() % 10 == 0: find_node("Tiles").set_cell(x, y, BLOCK)
				else: find_node("Tiles").set_cell(x, y, BRICK)
			elif tile_type == "L": find_node("Tiles").set_cell(x, y, LADDER)
			elif tile_type == "P": find_node("Tiles").set_cell(x, y, LADDER_TOP)
			elif tile_type == "7" and randi() % 3 == 0: find_node("Tiles").set_cell(x, y, SPIKES)
			#elif tile_type == "4" and randi() % 4 == 0: instance_create(xpos, ypos, oPushBlock)
			elif tile_type == "9":
				find_node("Tiles").set_cell(x, y + 1, BRICK) # block = find_node("Tiles").set_cell(x, y + 1, BRICK)
				if type == 0 or type == 1:
					find_node("Tiles").set_cell(x, y, ENTRANCE)
					find_node("Player").position = Vector2(x * 16 + 8, y * 16 + 8)
					globals.entrance_pos = Vector2(x, y)
				else:
					find_node("Tiles").set_cell(x, y, EXIT)
					globals.exit_pos = Vector2(x, y)
			#		block.invincible = true
			elif tile_type == "A":
				find_node("Tiles").set_cell(x, y, ALTAR_LEFT)
				find_node("Tiles").set_cell(x + 1, y, ALTAR_RIGHT)
			elif tile_type == "x":
				find_node("Tiles").set_cell(x, y, SAC_ALTAR_LEFT)
				find_node("Tiles").set_cell(x + 1, y, SAC_ALTAR_RIGHT)
				var statue = load("res://Scenes/KaliStatue.tscn").instance()
				statue.position = Vector2(x * 16, y * 16)
				add_child(statue)
			#elif tile_type == "I":
			#	instance_create(xpos+16, ypos+12, oGoldIdol)
			elif tile_type == "B":
				var statue = load("res://Scenes/TikiStatue.tscn").instance()
				statue.position = Vector2(x * 16, y * 16)
				add_child(statue)
			#elif tile_type == "Q":
			#	if shop_type == "Craps": tile_type_add(bgDiceSign, 0, 0, 48, 32, xpos, ypos, 9004)
			#elif tile_type == "q":
			#	n = randi() % 6 + 1
			#	scrGenerateItem(xpos+8, ypos+8, 1)
			#	obj.inDiceHouse = true
			#elif tile_type == "+":
			#	obj = instance_create(xpos, ypos, oSolid)
			#	obj.sprite_index = sIceBlock
			#	obj.shopWall = true
			#elif tile_type == "W":
			#	if global.murderer or global.thiefLevel > 0:
			#		if global.isDamsel: tile_type_add(bgWanted, 32, 0, 32, 32, xpos, ypos, 9004)
			#		elif global.isTunnelMan: tile_type_add(bgWanted, 64, 0, 32, 32, xpos, ypos, 9004)
			#		else: tile_type_add(bgWanted, 0, 0, 32, 32, xpos, ypos, 9004)
			#elif tile_type == "." and not collision_point(xpos, ypos, oSolid, 0, 0):
			#	if randi() % 10 == 0: obj = instance_create(xpos, ypos, oBlock)
			#	else: obj = instance_create(xpos, ypos, oBrick)
			#	obj.shopWall = true
			#elif tile_type == "b":
			#	obj = instance_create(xpos, ypos, oBrickSmooth)
			#	obj.shopWall = true
			#elif tile_type == "l":
			#	if has_damsel: instance_create(xpos, ypos, oLampRed)
			#	else: instance_create(xpos, ypos, oLamp)
			#elif tile_type == "K":
			#	obj = instance_create(xpos, ypos, oShopkeeper)
			#	obj.style = shop_type
			#elif tile_type == "k":
			#	obj = instance_create(xpos, ypos, oSign)
			#	if shop_type == "General": obj.sprite_index = sSignGeneral
			#	elif shop_type == "Bomb": obj.sprite_index = sSignBomb
			#	elif shop_type == "Weapon": obj.sprite_index = sSignWeapon
			#	elif shop_type == "Clothing": obj.sprite_index = sSignClothing
			#	elif shop_type == "Rare": obj.sprite_index = sSignRare
			#	elif shop_type == "Craps": obj.sprite_index = sSignCraps
			#	elif shop_type == "Kissing": obj.sprite_index = sSignKissing
			#elif tile_type == "i": scrShopItemsGen()
			#elif tile_type == "d": instance_create(xpos+8, ypos+8, oDice)
			#elif tile_type == "D":
			#	obj = instance_create(xpos+8, ypos+8, oDamsel)
			#	obj.forSale = true
			#	obj.status = 5
			elif tile_type == "s":
				if randi() % 10 == 0: pass #instance_create(xpos, ypos, oSnake)
				elif randi() % 2 == 0: find_node("Tiles").set_cell(x, y, BRICK)
			#elif tile_type == "S": instance_create(xpos, ypos, oSnake)
			#elif tile_type == "T": instance_create(xpos+8, ypos+8, oRubyBig)
			#elif tile_type == "M":
			#	instance_create(xpos, ypos, oBrick)
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
			rooms[current_room][old_layer] = 2
			if (rooms[current_room][old_layer - 1] > 4 and rooms[current_room][old_layer - 1] < 8) or rooms[current_room][old_layer - 1] == 13:
				rooms[current_room][old_layer] = 3
		elif current_layer != old_layer:
			rooms[current_room][current_layer] = 7
			if rooms[current_room][old_layer] == 0: rooms[current_room][old_layer] = 1
			if rooms[current_room][old_layer] == 5: rooms[current_room][old_layer] = 6
			if rooms[current_room][old_layer] == 7: rooms[current_room][old_layer] = 13
		elif rooms[current_room][current_layer] == 4:
			rooms[current_room][current_layer] = 5

	for layer in range(4):
		for room in range(4):
			generate_room(room, layer, globals.current_level, rooms[room][layer])

	for x in range(1, 41):
		for y in range(0, 33):
			if find_node("Tiles").get_cell(x, y) == BRICK:
				if find_node("Tiles").get_cell(x, y + 1) != BRICK: find_node("Tiles").set_cell(x, y, BRICK_DOWN)
				elif y > 0:
					if randi() % 10 == 0: find_node("Tiles").set_cell(x, y, BRICK2)
					var n = randi() % 100
					if n < 19: find_node("Tiles").set_cell(x, y, BRICK_GOLD)
					elif n < 29: find_node("Tiles").set_cell(x, y, BRICK_GOLD_BIG)
					#elif x > 0 and x < room_width-16 and y > 1 and y < room_height - 16:
					#	if randi() % 100 == 0: instance_create(x+8, y+8, oSapphireBig)
					#	elif randi() % 120 == 0: instance_create(x+8, y+8, oEmeraldBig)
					#	elif randi() % 140 == 0: instance_create(x+8, y+8, oRubyBig)
					#	elif randi() % 1200 == 0: scrGenerateItem(x+8, y+8, 2)
			if find_node("Tiles").get_cell(x, y) == SPIKES and find_node("Tiles").get_cell(x, y + 1) == EMPTY: find_node("Tiles").set_cell(x, y, EMPTY) # temporary fix

func _ready():
	randomize()
	generate_level()
