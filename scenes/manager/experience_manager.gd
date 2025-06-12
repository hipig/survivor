extends Node2D
class_name ExperienceManager

signal experience_updated(current_experience: float, target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH: float = 10.0

var current_level: int = 1
var current_experience: float = 0
var target_experience: float = 5
var total_experience: float = 0

func _ready() -> void:
	Events.experience_bottle_collected.connect(_on_experience_bottle_collected)

func increase_experience(value: float) -> void:
	total_experience += value
	current_experience += value
	experience_updated.emit(min(current_experience,target_experience), target_experience)
	if current_experience >= target_experience:
		current_level += 1
		current_experience -= target_experience
		target_experience += TARGET_EXPERIENCE_GROWTH
		experience_updated.emit(current_experience, target_experience)
		level_up.emit(current_level)
	
func _on_experience_bottle_collected(value: float) -> void:
	increase_experience(value)
