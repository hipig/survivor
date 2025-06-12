extends CanvasLayer
class_name ArenaTimeUI

@export var arena_time_manager: ArenaTimeManager

@onready var difficulty_label: Label = $MarginContainer/VBoxContainer/DifficultyLabel
@onready var left_time_label: Label = $MarginContainer/VBoxContainer/LeftTimeLabel

var total_difficulty: int
var current_difficulty: int
var left_time: String

func setup(initial_total_difficulty: int, initial_current_difficulty: int, initial_left_time: float) -> void:
	total_difficulty = initial_total_difficulty
	current_difficulty = initial_current_difficulty
	left_time = "%02d" % floor(initial_left_time)
	update()

func update_difficulty(update_current_difficulty: int) -> void:
	current_difficulty = update_current_difficulty
	update()

func update_left_time(update_time: float) -> void:
	left_time = "%02d" % floor(update_time)
	update()
	
func update() -> void:
	difficulty_label.text = "第 %s / %s 波" % [str(current_difficulty), str(total_difficulty)]
	left_time_label.text = left_time
