@tool
extends Node2D
class_name Key

enum LETTER_STATE {WAITING, TYPING}
@export var state : LETTER_STATE = LETTER_STATE.WAITING:
	set(value):
		state = value
		if not is_node_ready():
			return
		set_letter_and_frame()
		if value == LETTER_STATE.TYPING:
			timer.start(press_length)
			letter_pressed.emit(letter_val)

@onready var timer : Timer = $Timer
@onready var frame : Sprite2D = $frame
@onready var letter : Sprite2D = $letter

func set_letter_and_frame():
	letter.modulate = colors[state]
	frame.frame_coords = frames[state]

@export var press_length : float = .1
signal letter_changed(letter: String)
@export var letter_val: String = "A":
	set(value):
		letter_val = value
		if not is_node_ready():
			await ready
		if value == "":
			#print(error_string(ERR_CANT_RESOLVE))
			return
		elif value.unicode_at(0) >= 65 and value.unicode_at(0) <= 65+25:
			letter_val = value
			var ascii = letter_val.unicode_at(0)
			#print(ascii)
			ascii = ascii-65
			letter.frame_coords = Vector2i(ascii%9, int((ascii/9)%3))
			letter_changed.emit(letter_val)
		elif value == "del":
			#print('delete')
			pass
		elif value == "rtn":
			#print('submit')
			pass
		
		

const colors : Dictionary [LETTER_STATE, Color]= {
	LETTER_STATE.WAITING: Color("000000"),
	LETTER_STATE.TYPING: Color("FFFFFF")
}

const frames : Dictionary [LETTER_STATE, Vector2i]= {
	LETTER_STATE.WAITING: Vector2i(0,0),
	LETTER_STATE.TYPING: Vector2i(1,0)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	state = LETTER_STATE.WAITING


signal letter_pressed(letter:String)
func _on_key_pressed(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		state = LETTER_STATE.TYPING
		letter_pressed.emit(letter_val)
