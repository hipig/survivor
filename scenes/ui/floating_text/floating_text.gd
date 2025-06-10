extends Node2D

@export var heal_color: Color = Color("43e1b3")

@onready var label: Label = $Label

var is_heal: bool = false

func start(text: String) -> void:
	label.text = text
	if is_heal:
		label.add_theme_color_override("font_color", heal_color)
	else:
		label.remove_theme_color_override("font_color")
		
	var tween: Tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(self,"global_position", global_position + (Vector2.UP * 16), .3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.chain()
	
	tween.tween_property(self, "global_position", global_position + (Vector2.UP * 48), .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ZERO, .5)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_callback(queue_free)
	
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2.ONE, .15)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	scale_tween.tween_property(self, "scale", Vector2.ONE* 0.5, .15)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
