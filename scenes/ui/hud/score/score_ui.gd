extends CanvasLayer
class_name ScoreUI

@onready var score_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel

func _ready() -> void:
	update_score(0)
	
func update_score(score: int) -> void:
	score_label.text = str(score)
