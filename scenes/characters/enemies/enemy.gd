extends Character
class_name Enemy



@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var drop_component: DropComponent = $DropComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var state_machine: StateMachine = $StateMachine
