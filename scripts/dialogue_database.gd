extends Node
class_name DialogueDatabase

static var DIALOGUE_DATA = {
	"Beggar": {
		"default": [  # Before beer
			"Spare some change?",
			"I'm so thirsty...",
			"A cold beer would be nice..."
		],
		"after_beer": [  # After beer
			"Ahhh! You're a lifesaver!",
			"That hit the spot!",
			"Come back anytime, friend!"
		],
		"quest_complete": [  # After quest
			"Thanks again for the beer!",
			"You're a true hero!"
		]
	},
	"Igor": {
		"default": [
			"Hello, I'm Igor!",
			"Nice to meet you!",
			"Mind helping me get an item?"
		],
		"greeting": [  # After first talk but before quest
		"Come back if you change your mind.",
		"I'll be here if you need work."
		],
		"quest_started": [
			"So you'll help me? Thank you!",
			"The item is in the cave."
		]
	}
}

static func get_dialogue(character_name: String, state: String = "default") -> Array:
	if character_name in DIALOGUE_DATA:
		var character_data = DIALOGUE_DATA[character_name]
		return character_data.get(state, character_data.get("default", ["Hello!"]))
	return ["Hello!"]
