extends Tile

func _process(_delta):
	var globals = get_node("/root/Globals")
	var x = self.position.x / 16
	var y = self.position.y / 16
	
	if globals.current_level > 3:
		$AnimatedSprite.frame = 2
		if globals.get_tile_type(x, y + 1) != "Ladder": $AnimatedSprite.frame = 3
