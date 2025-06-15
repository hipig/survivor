extends PanelContainer
class_name  UpgradeCard

signal selected

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var name_label: Label = $MarginContainer/PanelContainer/MarginContainer/NameLabel
@onready var texture_rect: TextureRect = $VBoxContainer/MarginContainer/PanelContainer/TextureRect
@onready var level_label: Label = $VBoxContainer/MarginContainer/LevelLabel
@onready var description_label: Label = $VBoxContainer/MarginContainer2/DescriptionLabel

var disabled: bool = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func set_ability_upgrade(upgrade: Upgrade, equipped_upgrade: Dictionary) -> void:
	if equipped_upgrade.is_empty():
		equipped_upgrade = { level = 0 }
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	level_label.text = "Lv %d" % (equipped_upgrade.level + 1)
	texture_rect.texture = upgrade.icon

func play_in() -> void:
	animation_player.play("in")
	
func play_discard() -> void:
	animation_player.play("discard")

func select_card() -> void:
	disabled = true
	animation_player.play("selected")
	
	for other_card in Groups.get_upgrade_cards():
		if other_card == self:
			continue
		other_card.play_discard()
		
	selected.emit()

func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
		
	if event.is_action_pressed("upgrade_selected"):
		select_card()

func _on_mouse_entered() -> void:
	pass
	
func _on_mouse_exited() -> void:
	pass
