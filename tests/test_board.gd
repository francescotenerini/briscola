extends 'res://addons/gut/test.gd'


class TestBoard:
	extends "res://addons/gut/test.gd"

	var Board = load("res://Board.gd")
	var _board = null

	func before_each():
		_board = Board.new()

	func after_each():
		_board.queue_free()

	func test_create_deck():
		_board.create_deck()
		assert_eq(
			len(_board.deck),
			40,
			"Deck have " + str(len(_board.deck)) + "cards."
		)

	func test_init_board():
		_board.init_board()
		assert_eq(
			len(_board.deck),
			39,
			"Deck have " + str(len(_board.deck)) + "cards."
		)
		assert_not_null(_board.atont)
