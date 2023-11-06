extends Node

const cross = preload("res://images/X_icon.png")
const nought = preload("res://images/O_icon.png")
const blank = preload("res://images/Blank_icon_128px.png")

@onready var grid = $TokenContainer
@onready var status = $Label

var array = ["0","1","2","3","4","5","6","7","8"]
var mark_count: int = 0
var gameFinished: bool = false
var players_turn: bool = true
var timer = 1
var winning_marks =["t","",""]
var blink_timer = 0.25
var blinked = true

func _ready() -> void:
	status.hide()

func _process(delta: float) -> void:
	if not players_turn and not gameFinished:
		timer -= delta
	if timer < 0:
		choose_randomly()
		timer = 1
	if gameFinished and winning_marks[0] != "t":
		blink_timer -= delta
	if blink_timer < 0:
		blink_winner(blinked)
		blinked = !blinked
		blink_timer = 0.6


func reset_game() -> void:
	for icon in grid.get_children():
		icon.texture_disabled = blank
		icon.disabled = false
	array = ["0","1","2","3","4","5","6","7","8"]
	mark_count = 0
	gameFinished = false
	players_turn = true
	winning_marks = ["t", "", ""]
	status.hide()


func check_winner() -> int:
	# Check rows
	if array[0] == array[1] and array[1] == array[2]:
		return 1
	if array[3] == array[4] and array[4] == array[5]:
		return 2
	if array[6] == array[7] and array[7] == array[8]:
		return 3
	# Check columns
	if array[0] == array[3] and array[3] == array[6]:
		return 4
	if array[1] == array[4] and array[4] == array[7]:
		return 5
	if array[2] == array[5] and array[5] == array[8]:
		return 6
	# Check diagonals
	if array[0] == array[4] and array[4] == array[8]:
		return 7
	if array[2] == array[4] and array[4] == array[6]:
		return 8
	return 0


func match_int_to_name(number: int) -> String:
	var grid_block: String
	match number:
		0:
			grid_block = "TopLeft"
		1:
			grid_block = "TopMid"
		2:
			grid_block = "TopRight"
		3:
			grid_block = "MidLeft"
		4:
			grid_block = "Middle"
		5:
			grid_block = "MidRight"
		6:
			grid_block = "BottomLeft"
		7:
			grid_block = "BottomMid"
		8:
			grid_block = "BottomRight"
	return grid_block


func make_play(position: int) -> void:
	var char: String
	var grid_block = match_int_to_name(position)
	grid.get_node(grid_block).disabled = true
	if players_turn:
		char = "X"
		grid.get_node(grid_block).texture_disabled = cross
	else:
		char = "O"
		grid.get_node(grid_block).texture_disabled = nought
	array[position] = char
	mark_count += 1
	
	var winning_play = check_winner()
	if winning_play or mark_count == 9:
		gameFinished = true
		endstate(winning_play)
	else:
		players_turn = !players_turn


func choose_randomly() -> void:
	var valid = []
	var i = 0
	for item in array:
		if str(item) != "X" and str(item) != "O":
			valid.append(i)
		i += 1
	var choice = randi_range(0,valid.size()-1)
	make_play(valid[choice])


func endstate(winning_state: int) -> void:
	match winning_state:
		1:
			winning_marks = [match_int_to_name(0),match_int_to_name(1),match_int_to_name(2)]
		2:
			winning_marks = [match_int_to_name(3),match_int_to_name(4),match_int_to_name(5)]
		3:
			winning_marks = [match_int_to_name(6),match_int_to_name(7),match_int_to_name(8)]
		4:
			winning_marks = [match_int_to_name(0),match_int_to_name(3),match_int_to_name(6)]
		5:
			winning_marks = [match_int_to_name(1),match_int_to_name(4),match_int_to_name(7)]
		6:
			winning_marks = [match_int_to_name(2),match_int_to_name(5),match_int_to_name(8)]
		7:
			winning_marks = [match_int_to_name(0),match_int_to_name(4),match_int_to_name(8)]
		8:
			winning_marks = [match_int_to_name(2),match_int_to_name(4),match_int_to_name(6)]
		0:
			winning_marks = ["t","i","e"]
	status.show()
	for icon in grid.get_children():
		icon.disabled = true
	if winning_state > 0:
		if players_turn:
			status.text = "YOU WIN"
		else:
			status.text = "YOU LOSE"
	else:
		status.text = "TIE"


func blink_winner(is_visible: bool) -> void:
	var first = grid.get_node(winning_marks[0])
	var second = grid.get_node(winning_marks[1])
	var third = grid.get_node(winning_marks[2])
	
	var icon
	if players_turn:
		icon = cross
	else:
		icon = nought
	
	if is_visible:
		first.texture_disabled = blank
		second.texture_disabled = blank
		third.texture_disabled = blank
	else:
		first.texture_disabled = icon
		second.texture_disabled = icon
		third.texture_disabled = icon


func _on_top_left_pressed() -> void:
	if players_turn:
		make_play(0)

func _on_top_mid_pressed() -> void:
	if players_turn:
		make_play(1)

func _on_top_right_pressed() -> void:
	if players_turn:
		make_play(2)

func _on_mid_left_pressed() -> void:
	if players_turn:
		make_play(3)

func _on_middle_pressed() -> void:
	if players_turn:
		make_play(4)

func _on_mid_right_pressed() -> void:
	if players_turn:
		make_play(5)

func _on_bottom_left_pressed() -> void:
	if players_turn:
		make_play(6)

func _on_bottom_mid_pressed() -> void:
	if players_turn:
		make_play(7)

func _on_bottom_right_pressed() -> void:
	if players_turn:
		make_play(8)

func _on_reset_button_pressed() -> void:
	reset_game()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
