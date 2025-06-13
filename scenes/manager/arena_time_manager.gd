extends Node2D
class_name ArenaTimeManager

@export var max_difficulty: int = 20
@export var difficulty_time_interval: int = 20

@onready var timer: Timer = $Timer
@onready var all_time_in_run_timer: Timer = $AllTimeInRunTimer

var current_difficulty: int = 1
var difficulty_time: int = difficulty_time_interval

func _ready() -> void:
	Events.emit_arena_started(max_difficulty, current_difficulty, difficulty_time)
	timer.timeout.connect(on_timer_timeout)

func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left

func get_total_run_time() -> float:
	return all_time_in_run_timer.wait_time - all_time_in_run_timer.time_left

func get_time_left() -> float:
	return timer.time_left

func on_timer_timeout() -> void:
	if current_difficulty == max_difficulty:
		Events.emit_arena_timer_finished()
		return
	
	difficulty_time = max(0, difficulty_time - 1)
	Events.emit_arena_timer_updated(difficulty_time)
	
	if difficulty_time == 0:
		difficulty_time = difficulty_time_interval
		current_difficulty += 1
		Events.emit_arena_difficulty_increased(current_difficulty)
		
	timer.start()
