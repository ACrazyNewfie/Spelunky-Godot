extends Node2D

var player_speed = 96

func _process(delta):
	if Input.is_action_pressed("left"): self.position.x -= player_speed * delta
	if Input.is_action_pressed("right"): self.position.x += player_speed * delta
	if Input.is_action_pressed("up"): self.position.y -= player_speed * delta
	if Input.is_action_pressed("down"): self.position.y += player_speed * delta
