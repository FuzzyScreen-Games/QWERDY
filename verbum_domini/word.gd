@tool
extends Node2D
class_name Word

const width = 21
@export_range(4, 6, 1) var length : int = 4:
	set(value):
		if not is_node_ready():
			await ready
		length = value
		for child in  self.get_children():
			child.queue_free()
		letters = {}
		for i in range(length):
			var temp : Letter = letter.instantiate()
			self.add_child(temp)
			letters[i] = temp
			temp.global_position.x += i * width
@onready var letter : PackedScene = preload("res://verbum_domini/letter.tscn")

var letters : Dictionary[int, Letter] = {
	
}


signal submit_word(string:String)
var input_string : String
var input_pos : int = 0:
	set(value):
		input_pos = clamp(value, 0, 5)
func parse_letter(input: String) -> bool:
	print("parsing: " + input)
	if input == "rtn":
		if input_pos == 4:
			submit_word.emit(input_string)
		else:
			return false
	if input != "del":
		print('not delete')
		if input_pos != 5 and input_string.length() <= 5:
			print('inside')
			input_string += input
			input_pos = input_string.length()
	else:
		input_string = input_string.left(-1)
		input_pos -= 1
	for i in range(input_pos):
		if i == input_pos:
			letters[i].state = Letter.LETTER_STATE.TYPING_CURR
		else:
			letters[i].state = Letter.LETTER_STATE.TYPING
	return true
	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
