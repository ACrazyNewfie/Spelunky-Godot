extends Node

onready var globals = get_node("/root/Globals")

func _process(_delta):
	self.position = get_parent().find_node("Player").position
