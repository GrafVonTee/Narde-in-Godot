extends Node2D

class_name Board

#enum Direction {
#	Clockwise,
#	CounterClockwise
#}

export var tile_offset = Vector2(-62, 344)

var pits_array = []
onready var end_pits = [$WhitePit, $BlackPit]
var selected_pit = {}
#export var pits_direction = Direction.Clockwise


func _ready():
#	set_pits_direction()
	generate_pites()
	
	
#func set_pits_direction():
#	match pits_direction:
#		Direction.CounterClockwise:
#			var temp_pit_pos = $PitsOffset/PitA.position
#			$PitsOffset/PitA.position = $PitsOffset/PitD.position
#			$PitsOffset/PitD.position = temp_pit_pos
#			temp_pit_pos = $PitsOffset/PitB.position
#			$PitsOffset/PitB.position = $PitsOffset/PitC.position
#			$PitsOffset/PitC.position = temp_pit_pos


func connect_pit(pit, rot):
	pit.set_rotation(rot)
	pit.connect("chip_is_picked", self, "select_pit_directly")
	pit.connect("pit_is_picked", self, "select_destination_pit_directly")
	pit.calculate_first_position()


func generate_pites() -> void:
	var packed_pit = load("res://scenes/Pit.tscn")
	var cur_position = $PitsOffset/PitA.position
	for i in range(6*4):
		var new_pit = packed_pit.instance()
		add_child(new_pit)
		pits_array.push_back(new_pit)
		
		match i:
			Pit.Quarters.A:
				pass
			Pit.Quarters.B:
				cur_position = $PitsOffset/PitB.position
			Pit.Quarters.C:
				cur_position = $PitsOffset/PitC.position
				tile_offset.x *= -1
			Pit.Quarters.D:
				cur_position = $PitsOffset/PitD.position
			_:
				cur_position.x += tile_offset.x
				
		new_pit.set_tile_position(cur_position)
		connect_pit(new_pit, PI * (0 if i < 12 else 1))
	
	connect_pit($WhitePit, PI)
	connect_pit($BlackPit, 0)


func choose_by_quadrant(sel, dest: String):
	for key in Pit.Quarters:
		if Input.is_action_just_pressed("quadrant_"+key):
			get_tree().call_group("pits", "unselect_"+dest)
			for pit in pits_array.slice(Pit.Quarters[key], Pit.Quarters[key] + 5):
				pit.add_to_group("selected")
			get_tree().call_group("selected", "select_"+dest)
			sel = { Quad = Pit.Quarters[key], Number = -1 }
			break
	get_tree().call_group("selected", "unfollow_from_selected_group")
	return sel


func choose_by_number(sel, dest: String):
	for num in range(6):
		if (Input.is_key_pressed(KEY_0 + num+1) or
			Input.is_key_pressed(KEY_KP_0 + num+1)) and sel:
				
			get_tree().call_group("pits", "unselect_"+dest)
			sel.Number = num
			pits_array[sel.Quad + sel.Number].add_to_group("selected")
			get_tree().call_group("selected", "select_"+dest)
			break
			
	get_tree().call_group("selected", "unfollow_from_selected_group")
	return sel


func clear_board():
	get_tree().call_group("pits", "clear_pit")
