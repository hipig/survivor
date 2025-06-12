extends CanvasLayer
class_name ScoreUI

@onready var score_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel

var score: int = 0

func _ready() -> void:
	update_score(0, false)
	
func update_score(score: int) -> void:
	score_label.text = str(score)
