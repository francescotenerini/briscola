extends Area2D

var value: int = 0
var card_seed: int = 1
var point: int = 0
var strength: int = 0

var player: Node

onready var value_label = get_node("ValueLabel")
onready var seed_label = get_node("SeedLabel")


func update_ui():
	value_label.text = str(value)
	seed_label.text = str(enums.CardSeed.keys()[card_seed]).capitalize()


func _on_Card_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not player:
			return
		player.play_card(self)
