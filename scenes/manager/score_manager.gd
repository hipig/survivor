extends Node2D
class_name ScoreManager

var total_score: int = 0

func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)

func increase_score(value: int = 1) -> void:
	total_score += value
	Events.emit_score_updated(total_score)

func _on_enemy_died(_enemy: Enemy) -> void:
	increase_score()
