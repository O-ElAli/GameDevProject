extends Node
class_name DialogueDatabase

const DIALOGUE_DATA = {
	"Igor": [
		{"text": "Hello, I'm Igor!", "conditions": []},
		{"text": "Nice to meet you!", "conditions": []}
	],
	"Police_Chief": [
		{"text": "Welcome to the station.", "conditions": []},
	],
	"Bartender": [
		{"text": "The night is for celebrating, what can I do for you?", "conditions": []},
		{"text": "Drinks are on tap, stories are on the house.", "conditions": []}
	],
	"Kurogane": [
		{"text": "The NeoCorp boss is inside, go in. I’ll hold them off until the others catch up.", "conditions": []},
	],
	"Maya": [
		{"text": "Careful out there, the streets don’t forgive mistakes.", "conditions": []},
		{"text": "I used to run with the gangs. Now I just try to survive.", "conditions": []}
	],
	"Rafael": [
		{"text": "Cyberware’s nice, but it makes you a target too.", "conditions": []},
		{"text": "If you hear sirens, run first, ask questions later.", "conditions": []}
	],
	"Aiko": [
		{"text": "I heard NeoCorp is testing something new… people vanish.", "conditions": []},
		{"text": "You look tired. No shame in getting some rest while you can.", "conditions": []}
	],
	"Darius": [
		{"text": "Got a cigarette? Mine cost more than rent these days.", "conditions": []},
		{"text": "Used to be a cop. Didn’t like what I saw. Now I just keep my head down." , "conditions": []}
	],
	"Selene": [
		{"text": "The city lights hide the rot underneath.", "conditions": []},
		{"text": "If you’re looking for someone, I might know where to find them." , "conditions": []}
	],
	"Takemura": [
		{"text": "Keep moving. Standing still in this city gets you killed.", "conditions": []},
		{"text": "They say the net’s safer than the streets… they’re wrong." , "conditions": []}
	],
	"Yakuza Tensho": [
		{"text": "You're looking for the Boss? Then you must become the Champion of the Arena on the top floor.", "conditions": []}
	],
	"Yakuza Miro": [
		{"text": "Tonight is Fight Night.", "conditions": []}
	],
	"Yakuza Leon": [
		{"text": "The Boss knows everything that goes on in this city.", "conditions": []}
	],
	"Yakuza": [
	{"text": "Fight!Fight!Fight!!!", "conditions": []}
	],
	"Yakuza Fighter": [
	{"text": "AAARRRGGHHH!!!", "conditions": []}
	],
	"Alex": [
		{"text": "Another round for me, and make it quick.", "conditions": []}
	],
	"Sophia": [
		{"text": "I’ve seen things you wouldn’t believe.", "conditions": []}
	],
	"Sensei": [
		{"text": "Someone is vomiting badly in the bathroom, they have no self control.", "conditions": []}
	],
	"Lena": [
		{"text": "Keep your ears open, the right whispers pay off.", "conditions": []}
	],
	"David": [
		{"text": "The neon’s flickering again, but nobody listens.", "conditions": []}
	],
	"Akira": [
	{"text": "Careful, the coffee is hot, just like the night outside.", "conditions": []},
	{"text": "A little sugar makes the world easier to bear, don’t you think?", "conditions": []}
],
"Numi-13": [
	{"text": "I polished every glass twice, just for you.", "conditions": []},
	{"text": "This café is a safe place, no matter what chaos brews outside.", "conditions": []}
],
"X Æ A-12": [
	{"text": "Would you like something sweet or something strong?", "conditions": []},
	{"text": "Don’t worry, I’ll bring a smile with every order.", "conditions": []}
],
"Yumi": [
	{"text": "Welcome, Master! Your seat is ready.", "conditions": []},
	{"text": "Please relax, I’ll take care of everything.", "conditions": []}
],
"Amy": [
	{"text": "Your smile is my favorite tip.", "conditions": []}
],
"Ken": [
	{"text": "The coffee here tastes better than anywhere else.", "conditions": []}
],
"Zio": [
	{"text": "It feels safe here, like the world outside doesn’t exist.", "conditions": []}
],
"Taku": [
	{"text": "I come for the tea, but I stay for the company.", "conditions": []}
],
"V10-LA": [
	{"text": "101010101010101101010101", "conditions": []}
],
"Morrick": [
	{"text": "Shit... please don’t hurt me... Your brother isn’t really dead, you’ll learn everything about Project Nocturne on the PC. please...", "conditions": []}
],
"Secretary": [
	{"text": "On the left are the prisons if you want to visit someone, on the right is the archive, but we’re having some minor issues with the androids there. If you need help, just let me know.", "conditions": []}
],
"Officer Miller": [
		{"text": "Stay out of trouble and we won’t have a problem.", "conditions": []},
		{"text": "The cells are full tonight, don’t make me find you a spot.", "conditions": []}
	],
	"Officer John": [
		{"text": "Paperwork never ends in this city.", "conditions": []},
		{"text": "If you saw something, better report it fast.", "conditions": []}
	],
	"Officer Tanaka": [
		{"text": "We can’t protect everyone, but we try.", "conditions": []}
	],
		"Officer Mayhem": [
		{"text": "Keys, locks, and long nights, that’s my life down here", "conditions": []},
	],
		"Yakuza_Fight": [
		{"name":"Yakuza", "text": "Arrrgghh..", "conditions": []},
	],
		"NeoCorp_Fight": [
		{"name":"NeoCorpser", "text": "Ufff...", "conditions": []},
	],
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
