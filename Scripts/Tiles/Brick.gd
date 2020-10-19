extends Tile

var sprite_changed = false

func _process(_delta):
	if not sprite_changed:
		var globals = get_node("/root/Globals")
		var x = self.position.x / 16
		var y = self.position.y / 16
		var above
		var below
		
		if y == 0: above = globals.get_tile_type(x, y)
		else: above = globals.get_tile_type(x, y - 1)
		
		if y == 33: below = globals.get_tile_type(x, y)
		else: below = globals.get_tile_type(x, y + 1)

		if above != "Brick": $AnimatedSprite.frame = 2
		if below != "Brick": $AnimatedSprite.frame = 3
		if above != "Brick" and below != "Brick": $AnimatedSprite.frame = 4

		if not (x == 0 or x == 41 or y == 0 or y == 33) and $AnimatedSprite.frame == 0:
			if randi() % 10 == 0: $AnimatedSprite.frame = 1
			var n = randi() % 100
			if n < 19: $AnimatedSprite.frame = 5
			elif n < 29: $AnimatedSprite.frame = 6
			#elif x > 0 and x < room_width-16 and y > 1 and y < room_height - 16:
			#	if randi() % 100 == 0: instance_create(x+8, y+8, oSapphireBig)
			#	elif randi() % 120 == 0: instance_create(x+8, y+8, oEmeraldBig)
			#	elif randi() % 140 == 0: instance_create(x+8, y+8, oRubyBig)
			#	elif randi() % 1200 == 0: scrGenerateItem(x+8, y+8, 2)
		
		sprite_changed = true
