extends Enemy
class_name SlimeEnemy

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent

func _ready() -> void:
	hurt_box_component.hurted.connect(_on_hurted)
	health_component.died.connect(_on_died)

func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	update_animate_dirction()
	if velocity_component.direction.length() > 0:
		animated_sprite.play("move_" + animate_dirction)
	else:
		animated_sprite.play("idle_" + animate_dirction)
	

func _on_hurted(damage: float) -> void:
	health_component.damage(damage)

func _on_died() -> void:
	Events.emit_enemy_died(self)
	set_process(false)
	animated_sprite.play("die_" + animate_dirction)
	await animated_sprite.animation_finished
	queue_free()
