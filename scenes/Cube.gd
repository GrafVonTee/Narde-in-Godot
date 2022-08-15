extends Node2D

class_name Cube

var value: int
var is_used = false


func _ready():
	roll_die()
	
	
func set_value(val):
	value = val
	$Sprite.frame = val

func roll_die():
	value = randi() % 6
	$Sprite.frame = value
	
	
func make_die_used():
	if is_used:
		return
	is_used = true
	$Sprite.modulate.a /= 2
	$Sprite.set_modulate($Sprite.modulate.darkened(0.5))
	

func make_die_allowed_to_use():
	if not is_used:
		return
	is_used = false
	$Sprite.modulate.a = 255
	$Sprite.modulate = $Sprite.modulate.lightened(1)
	
	
func make_die_waiting():
	$Sprite.modulate.a /= 2
	$Sprite.set_modulate($Sprite.modulate.darkened(0.5))
