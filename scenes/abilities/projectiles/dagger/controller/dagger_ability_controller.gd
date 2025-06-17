extends AbilityController
class_name DaggerAbilityController

const DAGGER_ABILITY = preload("res://scenes/abilities/projectiles/dagger/dagger_ability.tscn")

func release(player: Player, foreground: Node2D, targetables: Array[Node]) -> void:
	targetables.sort_custom(func(a : Node2D, b:Node2D) -> bool:
		var a_distance: float = a.global_position.distance_squared_to(player.global_position)
		var b_distance: float = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
	)
	
	var emit_count: int = min(count, targetables.size())
	for i in range(emit_count):
		var target_direction = player.global_position.direction_to(targetables[i].global_position)
		var dagger_instance: DaggerAbility = DAGGER_ABILITY.instantiate()
		dagger_instance.global_position = player.global_position
		dagger_instance.damage = damage
		dagger_instance.direction = target_direction
		foreground.add_child(dagger_instance)
		
func upgrade_added(upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	match upgrade.id:
		"dagger_count":
			count += 1
