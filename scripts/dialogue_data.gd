extends Node
class_name DialogueDatabase

const DIALOGUE_DATA = {
	"Igor": [
		"Hello, I'm Igor!",
		"Nice to meet you!"
	],
	"Police_Chief": [
		"Welcome to the station.",
		"We have reports of suspicious activity."
	],
	"Bartender": [
		"What'll it be?",
		"We don't serve trouble-makers."
	]
}

static func get_dialogue(character_name: String) -> Array:
	return DIALOGUE_DATA.get(character_name, ["Hello!"])
