extends Tile

func _process(_delta):
	var globals = get_node("/root/Globals")

	if globals.current_level > 3:
		$AnimatedSprite.frame = 1
	elif globals.current_level > 7:
		$AnimatedSprite.frame = 2
