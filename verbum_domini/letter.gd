@tool
extends Node2D
class_name Letter

enum LETTER_STATE {TYPING, TYPING_CURR, CORRECT, CLOSE, INCORRECT}
@export var state : LETTER_STATE = LETTER_STATE.TYPING:
	set(value):
		state = value
		letter.modulate = colors[state]
		frame.frame_coords = frames[state]
		
@onready var frame : Sprite2D = $frame
@onready var letter : Sprite2D = $letter
signal letter_changed(letter: String)
@export var letter_val: String = "":
	set(value):
		letter_val = value
		letter_changed.emit(letter_val)
		if letter_val.to_upper() >= "A" and letter_val.to_upper() <= "Z":
			var ascii = letter_val.unicode_at(0)
			#print(ascii)
			ascii = ascii-65
			letter.frame = ascii
		elif letter_val == "":
			letter.frame = 26
			pass

const colors : Dictionary [LETTER_STATE, Color] = {
	LETTER_STATE.TYPING: Color("000000"),
	LETTER_STATE.TYPING_CURR: Color("808080"),
	LETTER_STATE.CORRECT: Color("FFFFFF"),
	LETTER_STATE.CLOSE: Color("FFFFFF"),
	LETTER_STATE.INCORRECT: Color("404040")
}
const frames : Dictionary [LETTER_STATE, Vector2i] = {
	LETTER_STATE.TYPING: Vector2i(0,1),
	LETTER_STATE.TYPING_CURR: Vector2i(1,1),
	LETTER_STATE.CORRECT: Vector2i(1,2),
	LETTER_STATE.CLOSE: Vector2i(0, 3),
	LETTER_STATE.INCORRECT: Vector2i(0,2)
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
