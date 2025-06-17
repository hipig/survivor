extends ProjectileAbility
class_name BoomerangAbility

var rotate_speed: float = 50.0

var ricochet_count: int = 3
var ricochet_range: float = 100.0
var returning: bool = false
var target_position: Vector2
var hit_targets: Array[Node]

func _process(delta: float) -> void:
	var target_direction = global_position.direction_to(target_position)
	position += target_direction * speed * delta
	rotate(target_direction.angle() * rotate_speed * delta)
	
	if global_position.distance_to(target_position) < 10.0:
		if returning:
			destroy()
		else:
			find_next_target()

func find_next_target() -> void:
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return not hit_targets.has(targetable) and global_position.distance_squared_to(targetable.global_position) < ricochet_range * ricochet_range
	)
	
	if targetables.size() == 0:
		return_to_player()
		return
	
	targetables.sort_custom(func(a : Node2D, b:Node2D) -> bool:
		var a_distance: float = a.global_position.distance_squared_to(global_position)
		var b_distance: float = b.global_position.distance_squared_to(global_position)
		return a_distance < b_distance
	)
	
	target_position = targetables[0].global_position

func return_to_player() -> void:
	var player = Groups.player
	if not player:
		return
		
	returning = true
	target_position = player.global_position

func _on_area_entered(area: Area2D) -> void:
	var area_owner: Node2D = area.owner
	hit_targets.append(area_owner)
	effect()
	
	ricochet_count -= 1
	
	if ricochet_count <= 0:
		return_to_player()
	else:
		find_next_target()
