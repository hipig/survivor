extends Node

const ENTITIES_LAYER = "entities_layer"
const FOREGROUND_LAYER = "foreground_layer"

const PLAYER: String = "player"
const ENEMIES = "enemies"
const TARGETABLES = "targetables"
const ABILITY_CONTROLLERS = "ability_controllers"

const CHARACTER_CARDS = "character_cards"
const UPGRADE_CARDS = "upgrade_cards"
const META_UPGRADE_CARDS = "meta_upgrade_cards"

var entities_layer: Node2D: get = get_entities_layer
var foreground_layer: Node2D: get = get_foreground_layer

var player: Player: get = get_player
var enemies: Array[Node]: get = get_enemies
var targetables: Array[Node] : get = get_targetables

var upgrade_cards: Array[Node]: get = get_upgrade_cards
var character_cards: Array[Node]: get = get_character_cards

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

func get_upgrade_cards() -> Array[Node]:
  return get_tree().get_nodes_in_group(UPGRADE_CARDS)

func get_character_cards() -> Array[Node]:
  return get_tree().get_nodes_in_group(CHARACTER_CARDS)
