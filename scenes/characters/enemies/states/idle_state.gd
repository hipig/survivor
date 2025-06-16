extends StateMachineState

func _on_enter(actor: Node) -> void:
	actor = actor as Enemy
	actor.animated_sprite.play("idle_" + actor.animate_direction)

func _on_next(actor: Node) -> void:
	actor = actor as Enemy
	
	if actor.velocity.length() > 0:
		transition.emit("Chase")
