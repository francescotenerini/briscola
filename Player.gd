extends Sprite

var points: int = 0
var hand: Array
var played_card_placeholder: Node
var played_card: Node

onready var points_label = get_node("PointsLabel")
onready var card_placeholder_1 = get_node("CardPlaceholder1")
onready var card_placeholder_2 = get_node("CardPlaceholder2")
onready var card_placeholder_3 = get_node("CardPlaceholder3")


func add_points(amount):
	points += amount
	points_label.text = "Points: " + str(points)


func _ready():
	add_points(0)


func display_card(card, placeholder):
	# display card on the placeolder
	card.position = placeholder.position
	card.rotation_degrees = placeholder.rotation_degrees
	add_child(card)
	card.update_ui()


func refresh_hand():
	if len(hand) >= 1:
		display_card(hand[0], card_placeholder_1)
	if len(hand) >= 2:
		display_card(hand[1], card_placeholder_2)
	if len(hand) == 3:
		display_card(hand[2], card_placeholder_3)


func add_card(card):
	if len(hand) >= 3:
		return
	print("Adding card ", card.value, " of ", card.card_seed)
	hand.append(card)
	card.player = self
	refresh_hand()


func hand_has_seed(a_seed):
	# Return true if the hand has a card with the passed seed
	for card in hand:
		if card.card_seed == a_seed:
			return true
	return false
