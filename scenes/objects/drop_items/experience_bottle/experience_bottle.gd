extends DropItem
class_name ExperienceBottle

@export var experience_value: float = 10.0

func collect(_collector: Node2D) -> void:
	Events.emit_experience_bottle_collected(experience_value)
