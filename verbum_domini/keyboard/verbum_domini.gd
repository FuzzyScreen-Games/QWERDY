extends Node2D
class_name Game

var curr_difficulty: WordBank.Difficulty
var curr_length : int
var is_daily : bool = true
var winning_word : String
var current_guesses : Dictionary[int, Dictionary]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func get_word(difficulty: WordBank.Difficulty, length : int) -> String:
	if length in [4, 5, 6]:
		return WordBank.get_daily_word(length, difficulty)
	return ""

func start_level(length: int, difficulty: WordBank.Difficulty, is_dly):
	curr_difficulty = difficulty
	curr_length = length
	is_daily = is_dly
	current_guesses = {}
	
	if is_daily:
		winning_word = WordBank.get_daily_word(curr_length, curr_difficulty)
	else:
		WordBank.get_random_word(curr_length, curr_difficulty)

func submit_word(word: String):
	if WordBank.is_valid_guess(word):
		var result = grade_word(word)
		current_guesses[current_guesses.size()] = result
		animate_results(result)

func animate_results(result : Array[Letter.LETTER_STATE]):
	var row : int = current_guesses.size() #0 index
	
	
	#tween stuff
	pass


func grade_word(word: String) -> Array[Letter.LETTER_STATE]:
	var letters : Array[Letter.LETTER_STATE]
	letters.resize(winning_word.length())
	letters.fill(Letter.LETTER_STATE.INCORRECT)
	for letter in range(word):
		if word[letter] == winning_word[letter]:
			letters[letter] = Letter.LETTER_STATE.CORRECT
		elif word[letter] in winning_word:
			letters[letter] = Letter.LETTER_STATE.CLOSE
	return letters

#if WordBank.is_valid_guess(player_input): ...
#var practice := WordBank.get_random_word(6, WordBank.Difficulty.INSANE)
