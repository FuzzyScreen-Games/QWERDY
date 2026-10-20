# word_bank.gd
# Add in Project Settings → Globals → Autoload, with the name "WordBank".
# Then from anywhere:  WordBank.get_daily_word(5, WordBank.Difficulty.HARD)
extends Node

const DB_PATH := "res://data/word_database.json"
# The day this is set to is puzzle #0. Never change it after launch.
const LAUNCH_DATE := "2026-11-01"

enum Difficulty { EASY, MEDIUM, HARD, INSANE }
const _TIER_KEYS: Array[String] = ["easy", "medium", "hard", "insane"]

# _answers[length][Difficulty] -> PackedStringArray, already in daily order
var _answers: Dictionary = {}
# _valid[length] -> { "WORD": true }  (a hash set, so lookups are O(1))
var _valid: Dictionary = {}


func _ready() -> void:
	var text := FileAccess.get_file_as_string(DB_PATH)
	if text.is_empty():
		push_error("WordBank: can't read %s (error %d)" % [DB_PATH, FileAccess.get_open_error()])
		return

	var data = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		push_error("WordBank: %s is not valid JSON" % DB_PATH)
		return

	# JSON keys are always strings ("5"), so convert them to ints once, here.
	for len_key: String in data["answers"]:
		var tiers := {}
		for d: int in Difficulty.values():
			tiers[d] = PackedStringArray(data["answers"][len_key][_TIER_KEYS[d]])
		_answers[int(len_key)] = tiers

	for len_key: String in data["valid_guesses"]:
		var lookup := {}
		for w: String in data["valid_guesses"][len_key]:
			lookup[w] = true
		_valid[int(len_key)] = lookup


## Gives the same word to every player on a given local calendar day.
func get_daily_word(length: int, difficulty: Difficulty) -> String:
	var pool := _pool(length, difficulty)
	if pool.is_empty():
		return ""
	return pool[posmod(get_day_number(), pool.size())]


## Free-play mode: a random word for players who want more than the daily.
func get_random_word(length: int, difficulty: Difficulty) -> String:
	var pool := _pool(length, difficulty)
	if pool.is_empty():
		return ""
	return pool[randi() % pool.size()]


func is_valid_guess(word: String) -> bool:
	var lookup: Dictionary = _valid.get(word.length(), {})
	return lookup.has(word.to_upper())


## Puzzle number (#0 on LAUNCH_DATE). Uses the player's local date, so
## everyone's puzzle changes at their own midnight, the way Wordle's does.
func get_day_number() -> int:
	var today := Time.get_date_string_from_system()  # local, "YYYY-MM-DD"
	var t0 := Time.get_unix_time_from_datetime_string(LAUNCH_DATE)
	var t1 := Time.get_unix_time_from_datetime_string(today)
	return floori((t1 - t0) / 86400.0)


func _pool(length: int, difficulty: Difficulty) -> PackedStringArray:
	if not _answers.has(length):
		push_error("WordBank: unsupported length %d" % length)
		return PackedStringArray()
	return _answers[length][difficulty]
