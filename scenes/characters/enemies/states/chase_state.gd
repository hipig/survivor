extends StateMachineState

func _on_update(_delta: float, actor: Node) -> void:
	actor = actor as Enemy
	actor.animated_sprite.play("move_" + actor.animate_direction)

func _on_next(actor: Node) -> void:
	actor = actor as Enemy
	
	if actor.velocity.length() == 0:
		transition.emit("Idle")
