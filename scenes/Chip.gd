extends StaticBody2D
class_name Chip

export (StreamTexture) var white_texture
export (StreamTexture) var black_texture

enum ChipColor {
	WHITE,
	BLACK,
}

enum State {
	PICKED,
	ONGOING,
	PLACED
}

signal was_picked
#signal was_placed

var blank = false
var state = State.PLACED
export var chip_speed = 2000
var color = ChipColor.WHITE

onready var path_follow: PathFollow2D

func _ready():
	set_process(false)

func set_color(col):
	var texture = {
		ChipColor.WHITE: white_texture,
		ChipColor.BLACK: black_texture,
	}
	
	$ChipSprite.set_texture(texture[col])
	color = col


func _process(delta):
	move_chip(delta)
	if path_follow.unit_offset == 1.0:
	#if path_follow.get_parent().curve.tessellate()[-1] == get_global_position():
		set_process(false)
		state = State.PLACED
		path_follow.get_parent().curve.clear_points()
		path_follow.get_parent().curve.add_point(get_global_position())

func move_chip(delta):
	path_follow.set_offset(path_follow.get_offset() + chip_speed * delta)


func pickChip():
	if state == State.PLACED:
		blank = false
		state = State.PICKED
		$LightingCircleference.changeToPicked()
		
		
func placeChip(pos: Vector2):
	path_follow = get_parent()
	path_follow.get_parent().curve.add_point(pos)
	state = State.ONGOING
	$LightingCircleference.changeToBased()
	set_process(true)


func select_chip():
	if state == State.PLACED and !blank:
		$LightingCircleference.turnOn()
		
		
func unselect_chip():
	if state == State.PLACED and !blank:
		$LightingCircleference.turnOff()
		
		
func makeBlank():
	blank = true
	$LightingCircleference.turnOff()
	
	
func makeActive():
	blank = false


func _input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("lmb_cllck") and not blank:
		emit_signal("was_picked")
