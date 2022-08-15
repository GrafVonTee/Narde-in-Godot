extends Node2D

class_name DiceUI

signal rolled

enum Placements {
	SQUARRED,
	LINE
}

export (PackedScene) var die_scene

var cubes_array = []
const dice_offset = 33
var cubes_count = 2
var can_double = true
export var current_placement = Placements.LINE
#var is_wait_for_roll = true


func init_new_cubes():
	for i in range(cubes_count):
		var cube = die_scene.instance()
		add_child(cube)
		cubes_array.append(cube)


func make_once():
	can_double = false
	change_count_of_dice(1)
	init_new_cubes()
	
	
func make_doubled():
	can_double = true
	change_count_of_dice(2)
	init_new_cubes()


func change_count_of_dice(num):
	for cube in cubes_array:
		cube.queue_free()
	cubes_array.clear()
	cubes_count = num
	

func is_timer_stopped():
	return $RollWaitTimer.is_stopped()
	
	
func set_wait_time(sec):
	$RollWaitTimer.wait_time = sec


func get_dice():
	return cubes_array
	
	
func get_one_die():
	return cubes_array[0]


func make_all_dice_active():
	for cube in cubes_array:
		cube.make_die_allowed_to_use()


func roll_dice():
	$RollWaitTimer.start()
	play_animation_rerolling_dice()


func play_animation_rerolling_dice():
	for cube in cubes_array:
		cube.visible = false
		
		
func stop_dice_animation():
	for cube in cubes_array:
		cube.visible = true


func double_cubes():
	var value = cubes_array[0].value
	init_new_cubes()
	for cube in cubes_array.slice(cubes_count, cubes_count * 2):
		cube.set_value(value)


func dice_rolled():
	change_count_of_dice(cubes_count)
	init_new_cubes()
	
	if (not cubes_count == 1) \
	and cubes_array[0].value == cubes_array[1].value \
	and can_double:
		double_cubes()
	
	for i in range(cubes_array.size()):
		if cubes_array.size() == 1:
			break
		cubes_array[i].position.x = dice_offset * (-1 if i % 2 else 1)
		if cubes_array.size() == 4:
			place_dice(i)
			
	stop_dice_animation()
	emit_signal("rolled", self)


func place_dice(index):
	match current_placement:
		Placements.SQUARRED:
			cubes_array[index].position.y = dice_offset * (-1 if index < 2 else 1)
		Placements.LINE:
			cubes_array[index].position.x *= 1 if index < 2 else 3
