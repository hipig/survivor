extends Node

signal arena_started(total_difficulty: int, current_difficulty: int, current_left_time: int)
signal arena_timer_updated(current_left_time: int)
signal arena_difficulty_increased(difficulty: int)
signal arena_timer_finished

signal experience_bottle_collected(value: float)
signal experience_updated(current_experience: float, target_experience: float)
signal level_up(current_level: int)
signal upgrades_generated(upgrades: Array[Upgrade], current_upgrades: Dictionary)

signal spawn_health_potion(spawn_position: Vector2)

signal player_damaged

signal enemy_damaged
signal enemy_died(enemy: Enemy)
signal score_updated(total_score: int)

func emit_arena_started(total_difficulty: int, current_difficulty: int, current_left_time: int) -> void:
	arena_started.emit(total_difficulty, current_difficulty, current_left_time)
	
func emit_arena_timer_updated(current_left_time: int) -> void:
	arena_timer_updated.emit(current_left_time)

func emit_arena_difficulty_increased(difficulty: int) -> void:
	arena_difficulty_increased.emit(difficulty)

func emit_arena_timer_finished() -> void:
	arena_timer_finished.emit()

func emit_experience_bottle_collected(value: float) -> void:
	experience_bottle_collected.emit(value)
	
func emit_experience_updated(current_experience: float, target_experience: float) -> void:
	experience_updated.emit(current_experience, target_experience)
	
func emit_level_up(current_level: int) -> void:
	level_up.emit(current_level)
	
func emit_upgrades_generated(upgrades: Array[Upgrade], current_upgrades: Dictionary) -> void:
	upgrades_generated.emit(upgrades, current_upgrades)

func emit_player_damaged() -> void:
	player_damaged.emit()
	
func emit_enemy_damaged() -> void:
	enemy_damaged.emit()

func emit_enemy_died(enemy: Enemy) -> void:
	enemy_died.emit(enemy)
	
func emit_score_updated(total_score: int) -> void:
	score_updated.emit(total_score)
