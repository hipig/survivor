extends StateMachineState

func _on_enter(actor: Node) -> void:
	actor = actor as Player
	if actor.is_dead:
		return
		
	actor.is_dead = true
	actor.player_has_died.emit()
	actor.abilities.set_process(false)
	actor.health_bar.visible = false
	actor.animated_sprite.play("die_" + actor.animate_direction)
	await actor.animated_sprite.animation_finished
