extends Node
class_name DialogueDatabase

const DIALOGUE_DATA = {
	"Igor": [
		{"text": "Hello, I'm Igor!", "conditions": []},
		{"text": "Nice to meet you!", "conditions": []}
	],
	"Police_Chief": [
		{"text": "Welcome to the station.", "conditions": []},
		{"text": "We have reports of suspicious activity.", "conditions": ["has_key_evidence"]}
	],
	"Bartender": [
		{"text": "What'll it be?", "conditions": []},
		{"text": "We don't serve trouble-makers.", "conditions": ["player_is_aggro"]}
	],
	"Kurogane": [
		{"text": "The NeoCorp boss is inside, go in. I’ll hold them off until the others catch up.", "conditions": []},
	]
}


static func get_dialogue(character_name: String, flags: Array = []) -> Array:
	var lines = DIALOGUE_DATA.get(character_name, [])
	var result = []
	
	for line in lines:
		if "conditions" in line:
			var show = true
			for cond in line["conditions"]:
				if cond not in flags:
					show = false
					break
			if show:
				result.append(line)
		else:
			result.append(line)
	
	return result
