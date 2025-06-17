extends ProjectileAbility
class_name DaggerAbility
	
func _on_area_entered(_area: Area2D) -> void:
	destroy()
