extends Node

signal experience_bottle_collected(value: float)
signal spawn_health_potion(spawn_position: Vector2)

signal player_damaged

signal enemy_damaged
signal enemy_died

func emit_experience_bottle_collected(value: float) -> void:
	experience_bottle_collected.emit(value)

func emit_player_damaged() -> void:
	player_damaged.emit()
	
func emit_enemy_damaged() -> void:
	enemy_damaged.emit()

func emit_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)
