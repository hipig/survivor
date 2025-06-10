extends Node

signal spawn_health_potion(spawn_position: Vector2)

signal player_damaged

signal enemy_damaged
signal enemy_died

func emit_player_damaged() -> void:
	player_damaged.emit()
	
func emit_enemy_damaged() -> void:
	enemy_damaged.emit()

func emit_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)
