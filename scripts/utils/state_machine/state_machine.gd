extends Node
class_name StateMachine

@export var initial_state: StateMachineState
@export var actor: Node

var states: Dictionary[String, StateMachineState]
var current_state: StateMachineState
var current_state_name: String:
	get:
		return current_state.name.to_lower()

func _ready() -> void:
	if !actor:
		actor = get_parent()
		
func start() -> void:
	for state in get_children():
		if state is StateMachineState:
			states[state.name.to_lower()] = state
			state.transition.connect(transition_to)
			
	if initial_state:
		initial_state._on_enter(actor)
		current_state = initial_state

func _process(delta : float) -> void:
	if current_state:
		current_state._on_update(delta, actor)
		current_state._on_next(actor)

func transition_to(state_name) -> void:
	if state_name == current_state.name.to_lower():
		return
	
	var new_state = states.get(state_name.to_lower())
	
	if !new_state:
		return
	
	if current_state:
		current_state._on_exit(actor)
	
	new_state._on_enter(actor)
	
	current_state = new_state
