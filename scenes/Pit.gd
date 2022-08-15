extends Area2D
class_name Pit

signal chip_is_picked
signal pit_is_picked

enum Quarters {
	A,
	B = 6,
	C = 12,
	D = 18
}

export var chipRadius = 28
var chipArray = []
var compress_offset = Vector2.ZERO
export var maximum_uncompressed_chips = 4
var first_position = Vector2.ZERO
var direction: float
var is_destination = false

# Tiling Functions
func get_tile_position() -> Vector2:
	return position
	
func set_tile_position(new_pos: Vector2) -> void:
	position = new_pos
	
func set_rotation(angle: float) -> void:
	rotation = angle
	direction = -1 if rotation else 1
	
func calculate_first_position():
	first_position = position - Vector2(0, 165 + chipRadius) * direction
	

# Stack of Chip Functions
	
func add_chip_to_pit(chip: Chip) -> void:
	for ch in chipArray:
		ch.makeBlank()
	chipArray.push_back(chip)
	chip.makeActive()
	chip.connect("was_picked", self, "call_board_that_chip_is_picked")
	if chipArray.size() > maximum_uncompressed_chips:
		compress_offset = Vector2(0, (330 - chipRadius) / chipArray.size())
		chip.placeChip(
			first_position +
			(Vector2(0, chipRadius * 2) + compress_offset * chipArray.size()) *
			direction
		)
		compressChips()
	else:
		chip.placeChip(
			first_position +
			Vector2(0, chipRadius * 2) * chipArray.size() *
			direction
		)
					
					
func compressChips():
	var chip_count = chipArray.size()
	for i in range(chip_count):
		var ch = chipArray[i]
		ch.z_index = i+1
		ch.placeChip(
			first_position +
			(Vector2(0, chipRadius * 2) + compress_offset * i) *
			direction
		)


func decompressChips():
	for i in range(chipArray.size()):
		chipArray[i].placeChip(
			first_position +
			Vector2(0, chipRadius * 2) * (i+1) *
			direction
		)


func pop_chip_from_pit() -> void:
	var chip: Chip = get_top_chip()
	chip.disconnect("was_picked", self, "call_board_that_chip_is_picked")
	chipArray.pop_back()
	if chipArray.size():
		chipArray[-1].makeActive()
		if chipArray.size() > maximum_uncompressed_chips:
			compress_offset = Vector2(0, (330 - chipRadius) / chipArray.size())
			compressChips()
		else:
			decompressChips()
	
	
func get_top_chip() -> Chip:
	return chipArray.back()


# Selections and Picking Pits

func pick_chip():
	if chipArray.size():
		get_top_chip().pickChip()
		
func select_pit():
	if is_destination:
		$MeshInstance2D.visible = true
	
func unselect_pit():
	if is_destination and not is_in_group("selected_lighted"):
		$MeshInstance2D.visible = false
		
func unpick_chip():
	if chipArray.size():
		var ch: Chip = get_top_chip()
		ch.placeChip(ch.get_global_position())

func select_chip():
	if chipArray.size():
		get_top_chip().select_chip()
	
func unselect_chip():
	if chipArray.size() and (not is_in_group("selected_lighted") or is_destination):
		get_top_chip().unselect_chip()

func unfollow_from_selected_group():
	if is_in_group("selected"):
		remove_from_group("selected")
		
func unfollow_from_picked_group():
	if is_in_group("picked"):
		remove_from_group("picked")
		
func unfollow_from_selected_lighted_group():
	if is_in_group("selected_lighted"):
		remove_from_group("selected_lighted")
		
func clear_pit():
	for ch in chipArray:
		ch.get_parent().get_parent().queue_free()
	chipArray.clear()
	
func is_empty():
	return not chipArray.size()

func get_color():
	return get_top_chip().color if chipArray.size() else 3
	
func call_board_that_chip_is_picked():
	if not is_destination:
		emit_signal("chip_is_picked", self)
	
func make_destination():
	is_destination = true
	if chipArray.size():
		get_top_chip().makeBlank()
	
func make_departer():
	is_destination = false
	if chipArray.size():
		get_top_chip().makeActive()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if Input.is_action_just_pressed("lmb_cllck") and is_destination:
				emit_signal("pit_is_picked", self)
				
func get_amount_of_chips():
	return chipArray.size()
