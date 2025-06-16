extends CharacterBody2D
class_name Character

var direction: Vector2 = Vector2.ZERO:
	set(dir): update_animate_direction(dir)
	
var animate_direction: String = "down"

func update_animate_direction(dir: Vector2) -> void:
	var x = abs(dir.x)
	var y = abs(dir.y)
	if x > y:
		if dir.x > 0:
			animate_direction = "right"
		else:
			animate_direction = "left"
	elif x < y:
		if dir.y > 0:
			animate_direction = "down"
		else:
			animate_direction = "up"
