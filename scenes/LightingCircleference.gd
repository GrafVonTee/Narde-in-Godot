extends Node2D

export var diam = 60
#export var shadow_diam = 57
export var based_color = Color("FFA400")
export var picked_chip_color = Color("009B77")
var color = based_color
var wasHighlighted = false


func _draw():
	if wasHighlighted:
		for i in range(5):
			var Col = { r = color.r, g = color.g, b = color.b, a = color.a }
			draw_circle(position, diam +(12) - i*3 \
				, Color(Col.r, Col.g, Col.b, Col.a - 0.6 + i * 0.1))
#	for i in range(5):
#		draw_circle(position, shadow_diam - i, Color(0, 0, 0, i * 0.1))


func turnOn():
	wasHighlighted = true
	update()


func turnOff():
	wasHighlighted = false
	update()


func changeToPicked():
	color = picked_chip_color
	wasHighlighted = true
	update()


func changeToBased():
	color = based_color
	wasHighlighted = false
	update()
