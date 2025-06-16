extends StateMachineState

func _on_enter(actor: Node) -> void:
	actor = actor as Player
	actor.animated_sprite.play("hit_" + actor.animate_direction)
	await actor.animated_sprite.animation_finished

func _on_next(_actor: Node) -> void:
	transition.emit("Idle")
