extends Node2D
class_name ExperienceManager

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
	Events.emit_experience_updated(min(current_experience,target_experience), target_experience)
	if current_experience >= target_experience:
		current_level += 1
		current_experience -= target_experience
		target_experience += TARGET_EXPERIENCE_GROWTH
		Events.emit_experience_updated(current_experience, target_experience)
		Events.emit_level_up(current_level)
	
func _on_experience_bottle_collected(value: float) -> void:
	increase_experience(value)
