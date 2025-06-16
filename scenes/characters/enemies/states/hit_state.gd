extends StateMachineState

func _on_enter(actor: Node) -> void:
	actor = actor as Enemy
	actor.animated_sprite.play("hit_" + actor.animate_direction)
	await actor.animated_sprite.animation_finished
