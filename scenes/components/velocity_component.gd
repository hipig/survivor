extends Node2D
class_name VelocityComponent

@export var max_speed: int = 40
@export var acceleration: float = 5

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO

func accelerate_to_player() -> Vector2:
	var owner_node2d: Node2D = owner as Node2D
	var player: Player = Groups.player
	if owner_node2d == null:
		return Vector2.ZERO
	
	if player == null or player.is_dead:
		return Vector2.ZERO
	
	var to_direction = owner_node2d.global_position.direction_to(player.global_position)
	direction = to_direction
	return accelerate_in_direction()

func accelerate_in_direction() -> Vector2:
	var desired_velocity: Vector2 = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1.0 - exp(-acceleration * get_process_delta_time()))
	return velocity
	
func decelerate() -> Vector2:
	direction = Vector2.ZERO
	return accelerate_in_direction()

func move(character_body: CharacterBody2D) -> void:
	character_body.velocity = velocity
	character_body.move_and_slide()
