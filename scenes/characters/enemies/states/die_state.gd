extends StateMachineState

func _on_enter(actor: Node) -> void:
	actor = actor as Enemy
	actor.animated_sprite.play("die_" + actor.animate_direction)
	await actor.animated_sprite.animation_finished
	actor.queue_free()
