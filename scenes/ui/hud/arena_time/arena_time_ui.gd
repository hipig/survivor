extends CanvasLayer
class_name ArenaTimeUI

@export var arena_time_manager: ArenaTimeManager

@onready var difficulty_label: Label = $MarginContainer/VBoxContainer/DifficultyLabel
@onready var left_time_label: Label = $MarginContainer/VBoxContainer/LeftTimeLabel

var total_difficulty: int
var current_difficulty: int
var left_time: String

func _ready() -> void:
	Events.arena_started.connect(_on_arena_started)
	Events.arena_timer_updated.connect(_on_arena_timer_updated)
	Events.arena_difficulty_increased.connect(_on_arena_difficulty_increased)

func setup(initial_total_difficulty: int, initial_current_difficulty: int, initial_left_time: int) -> void:
	total_difficulty = initial_total_difficulty
	current_difficulty = initial_current_difficulty
	left_time = "%02d" % initial_left_time
	update()

func update_difficulty(new_difficulty: int) -> void:
	current_difficulty = new_difficulty
	update()

func update_left_time(new_time: int) -> void:
	left_time = "%02d" % new_time
	update()
	
func update() -> void:
	difficulty_label.text = "第 %d / %d 波" % [current_difficulty, total_difficulty]
	left_time_label.text = left_time

func _on_arena_started(initial_total_difficulty: int, initial_current_difficulty: int, initial_left_time: int) -> void:
	setup(initial_total_difficulty, initial_current_difficulty, initial_left_time)

func _on_arena_difficulty_increased(difficulty: int) -> void:
	update_difficulty(difficulty)

func _on_arena_timer_updated(difficulty_time: int) -> void:
	update_left_time(difficulty_time)
