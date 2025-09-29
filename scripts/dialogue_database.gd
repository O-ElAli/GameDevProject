extends Node
class_name DialogueDatabase

static var DIALOGUE_DATA = {
	"Beggar": {
		"default": [  # Before getting beer
			"Spare some change?",
			"I'm so thirsty...",
			"A cold beer would be nice..."
		],
		"after_beer": [  # After giving beer
			"Thanks for the beer! You're a lifesaver!",
			"Now that I'm not thirsty, I noticed something shiny in the cave to the east.",
			"Check the cave east of here if you're looking for treasure!"
		]
	},
	"Igor": {
		"default": [
			"Hello traveler! I'm missing my ancient relic.",
			"Could you find my ancient relic? I lost it in the dark cave.",
			"Bring me the ancient relic from the cave and I'll reward you!"
		],
		"quest_complete": [
			"Thank you for finding my relic! Here's your reward.",
			"With this relic back, I can continue my research.",
			"Talk to the blacksmith about upgrading that sword I gave you!"
		]
	}
}

static func get_dialogue(character_name: String, state: String = "default") -> Array:
	if character_name in DIALOGUE_DATA:
		var character_data = DIALOGUE_DATA[character_name]
		return character_data.get(state, character_data.get("default", ["Hello!"]))
	return ["Hello!"]
