extends Node2D
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)
signal arena_timer_finished

@export var max_difficulty: int = 20
@export var difficulty_interval: int = 21

@onready var timer: Timer = $Timer
@onready var all_time_in_run_timer: Timer = $AllTimeInRunTimer

var current_difficulty: int = 1

func _ready() -> void:
	timer.wait_time = difficulty_interval
	timer.timeout.connect(on_timer_timeout)

func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left

func get_total_run_time() -> float:
	return all_time_in_run_timer.wait_time - all_time_in_run_timer.time_left

func get_time_left() -> float:
	return timer.time_left

func on_timer_timeout() -> void:
	if current_difficulty == max_difficulty:
		arena_timer_finished.emit()
		return
	
	current_difficulty += 1
	arena_difficulty_increased.emit(current_difficulty)
	timer.start()
