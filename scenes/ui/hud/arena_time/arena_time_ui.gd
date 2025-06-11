extends CanvasLayer
class_name ArenaTimeUI

@onready var difficulty_label: Label = $MarginContainer/VBoxContainer/DifficultyLabel
@onready var left_time_label: Label = $MarginContainer/VBoxContainer/LeftTimeLabel

func set_difficulty(current: int, total: int) -> void:
	difficulty_label.text = "第 %s / %s 波" % [str(current), str(total)]

func set_left_time(left_time: int) -> void:
	left_time_label.text = str(left_time)
