extends StateMachineState

func _on_update(_delta: float, actor: Node) -> void:
	actor = actor as Player
	actor.animated_sprite.play("walk_" + actor.animate_direction)
	
func _on_next(actor: Node) -> void:
	actor = actor as Player
	if actor.velocity.length() == 0:
		transition.emit("Idle")
