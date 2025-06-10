extends Node

const ENTITIES_LAYER = "entities_layer"
const FOREGROUND_LAYER = "foreground_layer"

const PLAYER: String = "player"
const ENEMIES = "enemies"
const TARGETABLES = "targetables"

var entities_layer: Node2D: get = get_entities_layer
var foreground_layer: Node2D: get = get_foreground_layer

var player: Player: get = get_player
var enemies: Array[Node]: get = get_enemies
var targetables: Array[Node] : get = get_targetables

func get_entities_layer() -> Node2D:
  return get_tree().get_first_node_in_group(ENTITIES_LAYER) as Node2D

func get_foreground_layer() -> Node2D:
  return get_tree().get_first_node_in_group(FOREGROUND_LAYER) as Node2D

func get_player() -> Player:
  return get_tree().get_first_node_in_group(PLAYER) as Player

func get_enemies() -> Array[Node]:
  return get_tree().get_nodes_in_group(ENEMIES)

func get_targetables() -> Array[Node]:
  return get_tree().get_nodes_in_group(TARGETABLES)
