extends Tile

onready var globals = get_node("/root/Globals")

func _process(_delta):
	var left = globals.get_tile_type(self.position.x / 16 - 1, self.position.y / 16)
	
	if left == "IdolAltar" or left == "SacAltar": $AnimatedSprite.frame = 1
