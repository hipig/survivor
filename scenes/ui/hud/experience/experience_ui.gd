extends CanvasLayer
class_name ExperienceUI

@onready var label: Label = $MarginContainer/VBoxContainer/MarginContainer2/Label
@onready var progress_bar_2: ProgressBar = $MarginContainer/VBoxContainer/MarginContainer/ProgressBar2
@onready var progress_bar: ProgressBar = $MarginContainer/VBoxContainer/MarginContainer/ProgressBar

func _ready() -> void:
	Events.experience_updated.connect(_on_experience_updated)
	Events.level_up.connect(_on_level_up)

func update_experience(current_experience: float, target_experience: float) -> void:
	var percent: float = current_experience / target_experience
	progress_bar_2.value = percent
	var tween: Tween = create_tween()
	tween.tween_property(progress_bar, "value", percent, 0.6)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	
func update_level(level: int) -> void:
	label.text = "LEVEL " + str(level)	

func _on_experience_updated(current_experience: float, target_experience: float) -> void:
	update_experience(current_experience, target_experience)

func _on_level_up(new_level: int) -> void:
	update_level(new_level)
