extends Tile

func _process(_delta):
	var globals = get_node("/root/Globals")
	match globals.shop_type:
		"General": $AnimatedSprite.frame = 1
		"Bomb": $AnimatedSprite.frame = 2
		"Weapon": $AnimatedSprite.frame = 3
		"Rare": $AnimatedSprite.frame = 4
		"Clothing": $AnimatedSprite.frame = 5
		"Craps": $AnimatedSprite.frame = 6
		"Kissing": $AnimatedSprite.frame = 7
