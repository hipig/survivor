extends AbilityController
class_name ArrowAbilityController

const ARROW_ABILITY = preload("res://scenes/abilities/projectiles/arrow/arrow_ability.tscn")

func release(player: Player, foreground: Node2D, targetables: Array[Node]) -> void:
	var emit_count: int = min(count, targetables.size())
	for i in range(emit_count):
		var index = randi_range(0, targetables.size() - 1)
		var target_direction = player.global_position.direction_to(targetables[index].global_position)
		var arrow_instance: ArrowAbility = ARROW_ABILITY.instantiate()
		arrow_instance.global_position = player.global_position
		arrow_instance.direction = target_direction
		arrow_instance.damage = damage
		
		foreground.add_child(arrow_instance)

func upgrade_added(_upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	pass
