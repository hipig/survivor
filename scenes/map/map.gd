extends Node2D
class_name Map

@onready var arena_time_manager: ArenaTimeManager = $ArenaTimeManager
@onready var enemy_manager: EnemyManager = $EnemyManager

func _ready() -> void:
	arena_time_manager.arena_difficulty_increased.connect(enemy_manager.difficulty_increased)
