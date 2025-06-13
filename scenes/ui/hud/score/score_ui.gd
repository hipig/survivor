extends CanvasLayer
class_name ScoreUI

@onready var score_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel

var score: int = 0

func _ready() -> void:
	update_score(0)
	Events.score_updated.connect(_on_score_updated)
	
func update_score(new_score: int) -> void:
	score_label.text = str(new_score)

func _on_score_updated(new_score: int) -> void:
	update_score(new_score)
