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
	var board = get_node("/root/Board")
	if not player:
		return
	if board.current_player != player:
		return

	if event is InputEventMouseButton and event.pressed:
		# TODO Check legal move: check ruling seed
		if not board.ruling_seed:
			board.ruling_seed = card_seed
		elif (
			board.ruling_seed != card_seed
			and player.hand_has_seed(board.ruling_seed)
		):
			return
		player.played_card = self
		# move the card from the player to the board
		player.remove_child(self)
		player.hand.remove(player.hand.find(self))
		board.add_child(self)
		position = player.played_card_placeholder.position
		rotation_degrees = player.played_card_placeholder.rotation_degrees
		# tell the board we have done
		board.next_player()
