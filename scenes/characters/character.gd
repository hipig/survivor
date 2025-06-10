extends CharacterBody2D
class_name Character

var animate_dirction: String = "down"

func update_animate_dirction() -> void:
	var x = abs(velocity.x)
	var y = abs(velocity.y)
	if x > y:
		if velocity.x > 0:
			animate_dirction = "right"
		else:
			animate_dirction = "left"
	elif x < y:
		if velocity.y > 0:
			animate_dirction = "down"
		else:
			animate_dirction = "up"
