extends Node2D
class_name Map

@onready var upgrade_manager: UpgradeManager = $UpgradeManager

func _ready() -> void:
	upgrade_manager.apply_upgrade(preload("res://resources/upgrades/abilities/arrow/arrow.tres"))
