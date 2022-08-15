extends Node2D

class_name GameBoard

enum WhichPlayerMove {
	WHITE,
	BLACK,
	NOBODY
}

#var pickedChip = null
#
#var cur_select = null
#var available_selections = []
#var destination_select = null
#var available_destinations = {}

var current_player = WhichPlayerMove.NOBODY

#var current_available_moves = []
#var used_moves = []
onready var players_dice = [$DiceWhite, $DiceBlack]

#var move_was_used = false
#var is_in_the_home = [false, false]
#export var maximum_value_of_chips = 15
#var chip_picked_from_head = false


func _ready():
	set_process(false)
	connect_dice()
	randomize()
	
	
func connect_dice():
	for d in players_dice:
		d.connect("rolled", self, "_dice_rolled")


func _input(event):
	if Input.is_action_just_pressed("reroll_dice"):
		$DiceWhite.roll_dice()


func _dice_rolled(dice):
	pass


#func _process(delta):
#	match current_player:
#		WhichPlayerMove.NOBODY: set_player()
#		_: make_move()


#func set_player():
#	if $WhiteDice.is_timer_stopped():
#		$TextLabel.set_label_text("Let's Choose the Player...")
#		current_player = choose_player()
#		roll_the_dice()


#func choose_player() -> int:
#	if current_available_moves.size() == 0:
#		return WhichPlayerMove.NOBODY
#	if current_available_moves.size() > 2:
#		return WhichPlayerMove.NOBODY
#	else:
#		return int(current_available_moves[0].value < current_available_moves[1].value)


#func determine_chips_in_the_home():
#	if is_in_the_home[current_player]:
#		return
#
#	var amount_of_chips = 0
#	for i in range(18 if current_player == 0 else 6, 24 if current_player == 0 else 12):
#		amount_of_chips += pits_array[i].get_amount_of_chips()
#	if amount_of_chips == maximum_value_of_chips:
#		is_in_the_home[current_player] = true
#		match current_player:
#			WhichPlayerMove.WHITE: $WhitePit.visible = true
#			WhichPlayerMove.BLACK: $BlackPit.visible = true
#
#
#func make_move():
#	if timer_just_stopped:
#		$TextLabel.set_label_text("Waiting the move from " \
#			+ ("WHITE" if current_player == WhichPlayerMove.WHITE else "BLACK") + " player")
#		timer_just_stopped = false
#		move_was_used = true
#
##	if move_was_used:
#	determine_chips_in_the_home()
#	find_available_selections_and_destinations()
##		move_was_used = false
#
#	if end_pits[current_player].get_amount_of_chips() == maximum_value_of_chips:
#		end_game()
#		return
#
#	if current_available_moves.size() == 0 and $CubeWaitTimer.is_stopped():
#		used_moves.clear()
#		current_player = (current_player + 1) % 2
#		roll_the_dice()
#		chip_picked_from_head = false
#	elif available_selections.size() == 0 and $CubeWaitTimer.is_stopped():
#		$TextLabel.set_label_text("You can't move your chips")
#		used_moves.clear()
#		current_player = (current_player + 1) % 2
#		roll_the_dice()
#		chip_picked_from_head = false
#
#
#func find_available_selections_and_destinations():
#	find_all_moves(pits_array, current_available_moves)
#
#
#func add_pit_to_selected(sel_pit, move, dest_pit):
#	sel_pit.select_chip()
#	available_selections.append(sel_pit)
#
#	if not available_destinations.has(sel_pit):
#		available_destinations[sel_pit] = { move: dest_pit }
#	else:
#		available_destinations[sel_pit][move] = dest_pit
#
#
#func find_all_moves(pits, moves):
#	available_destinations.clear()
#	available_selections.clear()
#
#	for pit in pits:
#		if pit.get_color() != current_player:
#			continue
#		for move in moves:
#			var index_moved_chip = pits_array.find(pit) + move.value
#			if pit.get_color() == WhichPlayerMove.BLACK:
#				index_moved_chip += 24
#				index_moved_chip %= 24
#
#			if pit.get_color() == WhichPlayerMove.WHITE:			
#				if index_moved_chip < 24 \
#				and (pits_array[index_moved_chip].is_empty() 
#				or pits_array[index_moved_chip].get_color() == current_player):
#
#					if pits_array.find(pit) != 0 or not chip_picked_from_head:	
#						add_pit_to_selected(pit, move, pits_array[index_moved_chip])
#
#				elif index_moved_chip >= 24 and is_in_the_home[current_player]:
#					add_pit_to_selected(pit, move, $WhitePit)
#
#			else:
#				if (pits_array.find(pit) >= 12
#				or (pits_array.find(pit) < 12 and index_moved_chip < 12) ) \
#				and (pits_array[index_moved_chip].is_empty() 
#				or pits_array[index_moved_chip].get_color() == current_player):
#
#					if pits_array.find(pit) != 12 or not chip_picked_from_head:	
#						add_pit_to_selected(pit, move, pits_array[index_moved_chip])
#
#				elif pits_array.find(pit) < 12 and index_moved_chip >= 12 \
#					and is_in_the_home[current_player]:
#						add_pit_to_selected(pit, move, $BlackPit)
#
#
#
#
#func start_game():
#	set_process(true)
#
#
#func end_game():
#	$TextLabel.set_label_text(
#		("Black" if current_player else "White") + " player WON!")
#	set_process(false)
#
#
#func choose_by_quadrant(sel, dest: String):
#	for key in Pit.Quarters:
#		if Input.is_action_just_pressed("quadrant_"+key):
#			get_tree().call_group("pits", "unselect_"+dest)
#			for pit in pits_array.slice(Pit.Quarters[key], Pit.Quarters[key] + 5):
#				pit.add_to_group("selected")
#			get_tree().call_group("selected", "select_"+dest)
#			sel = { Quad = Pit.Quarters[key], Number = -1 }
#			break
#	get_tree().call_group("selected", "unfollow_from_selected_group")
#	return sel
#
#
#func choose_by_number(sel, dest: String):
#	for num in range(6):
#		if (Input.is_key_pressed(KEY_0 + num+1) or
#			Input.is_key_pressed(KEY_KP_0 + num+1)) and sel:
#
#			get_tree().call_group("pits", "unselect_"+dest)
#			sel.Number = num
#			pits_array[sel.Quad + sel.Number].add_to_group("selected")
#			get_tree().call_group("selected", "select_"+dest)
#			break
#
#	get_tree().call_group("selected", "unfollow_from_selected_group")
#	return sel
#
#
#func clear_pits_variables():
#	get_tree().call_group("selected_lighted", "unfollow_from_selected_lighted_group")
#	get_tree().call_group("pits", "unselect_pit")
#	get_tree().call_group("pits", "unselect_chip")
#	get_tree().call_group("pits", "make_departer")
#	get_tree().call_group("picked", "unpick_chip")
#	get_tree().call_group("picked", "unfollow_from_picked")
#	pickedChip = null
#	cur_select = null
#	destination_select = null
#	move_was_used = true
#
#
#func select_current_pit():
#	var cur_pit: Pit = pits_array[cur_select.Quad + cur_select.Number]
#	if not (cur_pit in available_selections) or cur_pit.is_empty():
#		cur_select = null
#		return
#
#	get_tree().call_group("selected_lighted", "unfollow_from_selected_lighted_group")
#	get_tree().call_group("pits", "unselect_pit")
#	get_tree().call_group("picked", "unpick_chip")
#	get_tree().call_group("picked", "unfollow_from_picked_group")
#
#	pickedChip = cur_pit.get_top_chip()
#
#	get_tree().call_group("pits", "make_destination")
#
#	cur_pit.add_to_group("picked")
#	get_tree().call_group("picked", "pick_chip")
#	get_tree().call_group("picked", "make_departer")
#
#	for pit in available_destinations[cur_pit].values():
#		pit.add_to_group("selected_lighted")
#	get_tree().call_group("selected_lighted", "select_pit")
#
#
#func select_pit_directly(pit: Pit):
#	var index = pits_array.find(pit)
#	cur_select = { Quad = int(index / 6) * 6, Number = -1 }
#	cur_select.Number = index - cur_select.Quad
#	select_current_pit()
#
#
#func select_destination_pit(d_pit: Pit):
#	var cur_pit = pits_array[cur_select.Quad + cur_select.Number]
#	var dest_pit
#	if pits_array.find(d_pit) == -1:
#		dest_pit = d_pit
#	else:
#		dest_pit = pits_array[destination_select.Quad + destination_select.Number]
#	var available_move = null
#
#	for move in available_destinations[cur_pit].keys():
#		if available_destinations[cur_pit][move] == dest_pit:
#			available_move = move
#			break
#
#	if not available_move:
#		return
#
#	if pits_array.find(cur_pit) != (12 * current_player) or not chip_picked_from_head:	
#		cur_pit.pop_chip_from_pit()
#		dest_pit.add_chip_to_pit(pickedChip)
#		used_moves.append(available_move)
#		current_available_moves.remove(current_available_moves.find(available_move))
#		print(cur_pit, " ", pits_array.find(cur_pit))
#		if pits_array.find(cur_pit) == (12 * current_player):
#			chip_picked_from_head = true
#		clear_pits_variables()
#
#
#func select_destination_pit_directly(pit: Pit):
#	var index = pits_array.find(pit)
#	destination_select = { Quad = int(index / 6) * 6, Number = 0 }
#	destination_select.Number = index - destination_select.Quad
#	select_destination_pit(pit)
#
#
#func escape_from_pit():
#	if Input.is_key_pressed(KEY_ESCAPE):
#		clear_pits_variables()
#
#
#func _input(event):
#	if current_available_moves.size():
#		if !pickedChip:
#			cur_select = choose_by_quadrant(cur_select, "chip")
#			cur_select = choose_by_number(cur_select, "chip")
#			if Input.is_key_pressed(KEY_SPACE):
#				select_current_pit()
#		else:
#			destination_select = choose_by_quadrant(destination_select, "pit")
#			destination_select = choose_by_number(destination_select, "pit") 
#			if Input.is_key_pressed(KEY_SPACE):
#				select_destination_pit(pits_array[destination_select.Quad + destination_select.Number])
#
#		escape_from_pit()
#
#	if Input.is_action_just_pressed("ui_home"):
#		spawn_chips()
#		start_game()
#	if Input.is_action_just_pressed("ui_end"):
#		clear_board()
#		get_tree().reload_current_scene()
#	if Input.is_action_just_pressed("reroll_dice"):
#		roll_the_dice()
#
#
#func spawn_chips():
#	for color in Chip.ChipColor:
#		for i in range(maximum_value_of_chips):
#			var path = Path2D.new()
#			var follow_path = PathFollow2D.new()
#			var chip = load("res://scenes/Chip.tscn").instance()
#			chip.set_color(Chip.ChipColor[color])
#
#			get_tree().get_root().add_child(path)
#			path.add_child(follow_path)
#			follow_path.add_child(chip)
#
#			path.curve.add_point(get_viewport().size)
#			follow_path.loop = false
#			follow_path.rotate = false
#
#			pits_array[Chip.ChipColor[color] * 12].add_chip_to_pit(chip)
#
#
#func clear_board():
#	get_tree().call_group("pits", "clear_pit")
