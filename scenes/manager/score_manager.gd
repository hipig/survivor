extends Node2D
class_name ScoreManager

signal score_updated

var total_score: int = 0

func increase_score(value: int = 1) -> void:
	total_score += value
	score_updated.emit(total_score)
