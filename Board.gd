extends Node2D

var deck: Array
var Card = preload("res://Card.tscn")

var current_player: Node
var ruling_seed: int
var atont: Node
var atont_card_seed: int
var last_turn: bool = false

onready var atont_placeholder = get_node("AtontPlaceholder")
onready var player1 = get_node("Player1")
onready var player2 = get_node("Player2")
onready var played_card_placeholder_1 = get_node("PlayedCard1Placeholder")
onready var played_card_placeholder_2 = get_node("PlayedCard2Placeholder")


func create_deck():
	var points_map = {
		1: 11, 2: 0, 3: 10, 4: 0, 5: 0, 6: 0, 7: 0, 8: 2, 9: 3, 10: 4
	}
	var strength_map = {
		1: 10, 2: 1, 3: 9, 4: 2, 5: 3, 6: 4, 7: 5, 8: 6, 9: 7, 10: 8
	}
	# Create the deck
	for c_seed in enums.CardSeed.values():
		for val in range(1, 11):
			var card = Card.instance()
			card.value = val
			card.card_seed = c_seed
			card.point = points_map[val]
			card.strength = strength_map[val]
			deck.append(card)
	deck.shuffle()


func init_board():
	create_deck()
	# pick atont card
	atont = deck.pop_front()
	atont.position = atont_placeholder.position
	atont.rotation_degrees = atont_placeholder.rotation_degrees
	add_child(atont)
	atont.update_ui()
	atont_card_seed = atont.card_seed
	# Initialize players heand (3 cards per player)
	player1.played_card_placeholder = played_card_placeholder_1
	player2.played_card_placeholder = played_card_placeholder_2
	player1.add_card(deck.pop_front())
	player2.add_card(deck.pop_front())
	player1.add_card(deck.pop_front())
	player2.add_card(deck.pop_front())
	player1.add_card(deck.pop_front())
	player2.add_card(deck.pop_front())
	current_player = player1


func _ready() -> void:
	randomize()
	init_board()


func get_winner():
	print("Atont is ", atont_card_seed)
	print(
		"Player 1 played ",
		player1.played_card.value,
		" of ",
		player1.played_card.card_seed
	)
	print(
		"Player 2 played ",
		player2.played_card.value,
		" of ",
		player2.played_card.card_seed
	)
	# atont seed check
	if (
		player1.played_card.card_seed == atont_card_seed
		and player2.played_card.card_seed != atont_card_seed
	):
		return player1
	if (
		player1.played_card.card_seed != atont_card_seed
		and player2.played_card.card_seed == atont_card_seed
	):
		return player2
	if (
		player1.played_card.card_seed == atont_card_seed
		and player2.played_card.card_seed == atont_card_seed
	):
		# Check card strength
		if player1.played_card.strength > player2.played_card.strength:
			return player1
		else:
			return player2
	# ruling seed check
	if (
		player1.played_card.card_seed == ruling_seed
		and player2.played_card.card_seed != ruling_seed
	):
		return player1
	if (
		player1.played_card.card_seed != ruling_seed
		and player2.played_card.card_seed == ruling_seed
	):
		return player2
	else:
		# Check card strength
		if player1.played_card.strength > player2.played_card.strength:
			return player1
		else:
			return player2


func check_end_turn():
	if player1.played_card and player2.played_card:
		var winner = get_winner()
		var loser = null
		winner.add_points(player1.played_card.point + player2.played_card.point)

		player1.played_card.queue_free()
		player2.played_card.queue_free()
		player1.played_card = null
		player2.played_card = null
		ruling_seed = 0
		if not last_turn:
			# Give another card to both players
			winner.add_card(deck.pop_front())
			if winner == player1:
				loser = player2
			else:
				loser = player1
			if len(deck) > 0:
				loser.add_card(deck.pop_front())
			else:
				if not last_turn:
					remove_child(atont)
					loser.add_card(atont)
					last_turn = true
		elif len(player1.hand) == 0 and len(player2.hand) == 0:
			# Check game winner
			if player1.points > player2.points:
				print("The winner is player1")
			elif player2.points > player1.points:
				print("The winner is player2")
			else:
				print("The game is a draw")
			get_tree().reload_current_scene()
		current_player = winner


func next_player():
	if current_player == player1:
		current_player = player2
	else:
		current_player = player1
	check_end_turn()
