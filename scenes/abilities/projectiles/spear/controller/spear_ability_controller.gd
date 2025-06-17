extends AbilityController
class_name SpearAbilityController

const SPEAR_ABILITY = preload("res://scenes/abilities/projectiles/spear/spear_ability.tscn")

@export var pierce_count: int = 3

func release(player: Player, foreground: Node2D, targetables: Array[Node]) -> void:
	var best_direction: Vector2 = find_best_direction(player)
	if best_direction == Vector2.ZERO:
		return
		
	var emit_count: int = min(count, targetables.size())
	for i in range(emit_count):
		var spear_instance: SpearAbility = SPEAR_ABILITY.instantiate()
		spear_instance.global_position = player.global_position
		spear_instance.pierce_count = pierce_count
		spear_instance.direction = best_direction
		spear_instance.damage = damage
		foreground.add_child(spear_instance)

func find_best_direction(player: Player) -> Vector2:
	var targetables: Array[Node] = Groups.targetables
	targetables = targetables.filter(func(targetable: Node2D) -> bool: 
		return targetable.global_position.distance_squared_to(player.global_position) < max_range * max_range
	)
	
	if targetables.size() == 0:
		return Vector2.ZERO
	
	var sector_count: int = 32
	var sector_size: float = TAU / sector_count
	var sector_counts: Array = []
	sector_counts.resize(sector_count)
	sector_counts.fill(0)
	for targetable: Node2D in targetables:
		var direction = player.global_position.direction_to(targetable.global_position)
		var angle = atan2(direction.y, direction.x)
		if angle < 0:
			angle += TAU

		var sector_index: int = int(floor(angle / sector_size)) % sector_count
		sector_counts[sector_index] += 1
		
	var max_count = 0
	var best_sector = 0
	for i in range(sector_count):
		if sector_counts[i] > max_count:
			max_count = sector_counts[i]
			best_sector = i
			
	var best_angle = best_sector * sector_size + sector_size / 2.0
	return Vector2(cos(best_angle), sin(best_angle))

func upgrade_added(upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"spear_pierce":
			pierce_count += 1
