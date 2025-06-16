extends Enemy
class_name BaseEnemy

func _ready() -> void:
	state_machine.start()
	hurt_box_component.hurted.connect(_on_hurted)
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)

func _on_hurted(damage: float) -> void:
	health_component.damage(damage)
	state_machine.transition_to("Hit")

func _on_died() -> void:
	Events.emit_enemy_died(self)
	state_machine.transition_to("Die")
