@tool
extends Node2D
class_name Keyboard


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var children = self.get_children()
	for child in children:
		if child is Key:
			var key : Key = child
			key.letter_pressed.connect(_key_pressed)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER:
			%enter.state = Key.LETTER_STATE.TYPING
		elif event.keycode == KEY_BACKSPACE:
			%backspace.state = Key.LETTER_STATE.TYPING
		elif event.keycode >= KEY_A and event.keycode <= KEY_Z:
			# event.as_text() will return a clean "A", "B", "C", etc.
			var typed_letter = event.as_text().to_upper()
			var letter : Key = get_node(typed_letter)
			letter.state = Key.LETTER_STATE.TYPING
			
signal key_pressed(value: String)
func _key_pressed(value: String):
	key_pressed.emit(value)
	print(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
