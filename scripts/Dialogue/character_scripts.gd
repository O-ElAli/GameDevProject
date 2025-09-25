extends Node2D

var dialogue = [
	{ "speaker": "NAVI", "line": "Good morning, junk-face! Hungover again?" },
	{ "speaker": "NAVI", "line": "Honestly, you should lay off the cheap booze." },
	{ "speaker": "Player", "line": "...My brother really is dead" }
]

func _ready():
	for entry in dialogue:
		print(entry.speaker + ": " + entry.line)
