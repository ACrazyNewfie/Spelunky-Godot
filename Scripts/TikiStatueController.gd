extends Node

func _ready():
	$LeftArm.frame = randi() % 3
	$RightArm.frame = randi() % 3
