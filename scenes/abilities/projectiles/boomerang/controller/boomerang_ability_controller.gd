extends AbilityController
class_name BoomerangAbilityController

const BOOMERANG_ABILITY = preload("res://scenes/abilities/projectiles/boomerang/boomerang_ability.tscn")

func release(player: Player, foreground: Node2D, targetables: Array[Node]) -> void:
	var emit_count: int = min(count, targetables.size())
	for i in range(emit_count):
		var boomerang_instance: BoomerangAbility = BOOMERANG_ABILITY.instantiate()
		boomerang_instance.global_position = player.global_position
		boomerang_instance.target_position = targetables[i].global_position
		boomerang_instance.damage = damage
		foreground.add_child(boomerang_instance)

func upgrade_added(_upgrade: Upgrade, _current_upgrades: Dictionary) -> void:
	pass
