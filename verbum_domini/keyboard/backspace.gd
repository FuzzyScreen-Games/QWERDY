@tool
extends Key
class_name Backspace


@onready var letter_mid : Sprite2D = $letter_mid
@onready var letter_right : Sprite2D = $letter_right


func set_letter_and_frame():
	super.set_letter_and_frame()
	letter_mid.modulate = colors[state]
	letter_right.modulate = colors[state]

	
