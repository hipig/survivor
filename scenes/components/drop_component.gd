extends Node2D
class_name DropComponent

@export var drop_list: Array[DropData]
@export var drop_value: float = 1.0
@export var is_spawn_around_pos: bool = true
@export var gravity: float = 300.0
@export var bounce_height: float = 30.0
@export var bounce_duration: float = 0.5

var velocity: Vector2 = Vector2.ZERO

func random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())
	
func drop() -> void:
	if drop_list.size() == 0:
		return
	
	for drop_data in drop_list:
		var adjusted_drop_probability: float = drop_data.probability
		if randf() > adjusted_drop_probability:
			return
			
		if not drop_data.item:
			return
			
		if not owner is Node2D:
			return
		
		var spawn_position: Vector2 = (owner as Node2D).global_position
		if is_spawn_around_pos:
			spawn_position = spawn_position + random_inside_unit_circle() * 15

		var drop_item_instance: = drop_data.item.instantiate() as Node2D
		drop_item_instance.global_position = spawn_position
		Groups.entities_layer.add_child(drop_item_instance)
