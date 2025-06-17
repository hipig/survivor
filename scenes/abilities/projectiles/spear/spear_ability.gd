extends ProjectileAbility
class_name SpearAbility

var pierce_count: int = 3
	
func _on_area_entered(_area: Area2D) -> void:
	effect()
	pierce_count -= 1
	
	if pierce_count <= 0:
		destroy()
