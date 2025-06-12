extends Node2D
class_name Map

@onready var arena_time_ui: ArenaTimeUI = $ArenaTimeUI
@onready var score_ui: ScoreUI = $ScoreUI
@onready var experience_ui: ExperienceUI = $ExperienceUI
@onready var arena_time_manager: ArenaTimeManager = $ArenaTimeManager
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var score_manager: ScoreManager = $ScoreManager
@onready var experience_manager: ExperienceManager = $ExperienceManager

func _ready() -> void:
	arena_time_ui.setup(arena_time_manager.max_difficulty, arena_time_manager.current_difficulty, arena_time_manager.difficulty_interval)
	arena_time_manager.arena_difficulty_increased.connect(_on_arena_difficulty_increased)
	experience_manager.experience_updated.connect(_on_experience_updated)
	experience_manager.level_up.connect(_on_level_up)
	Events.enemy_died.connect(_on_enemy_died)

func _process(_delta: float) -> void:
	arena_time_ui.update_left_time(arena_time_manager.get_time_left())

func _on_arena_difficulty_increased(difficulty: int) -> void:
	enemy_manager.increase_difficulty(difficulty)
	arena_time_ui.update_difficulty(difficulty)

func _on_enemy_died(_enemy: Enemy) -> void:
	score_manager.increase_score()
	score_ui.update_score(score_manager.total_score)
	enemy_manager.spawn_count -= 1

func _on_experience_updated(current_experience: float, target_experience: float) -> void:
	experience_ui.update_experience(current_experience, target_experience)
	
func _on_level_up(level: int) -> void:
	experience_ui.update_level(level)
		
