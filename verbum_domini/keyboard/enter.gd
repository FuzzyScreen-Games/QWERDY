@tool
extends Key
class_name Enter

@onready var letter2 : Sprite2D = $letter2
@onready var letter3 : Sprite2D = $letter3
@onready var letter4 : Sprite2D = $letter4
@onready var letter5 : Sprite2D = $letter5

func set_letter_and_frame():
	super.set_letter_and_frame()
	letter2.modulate = colors[state]
	letter3.modulate = colors[state]
	letter4.modulate = colors[state]
	letter5.modulate = colors[state]
