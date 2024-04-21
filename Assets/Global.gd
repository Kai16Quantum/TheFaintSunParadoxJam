extends Node

var astargrid
var alien_word_list = [
	"ME", "YOU", "IT", "RUN", "DIE", "FIGHT", "HELP", "NO", "YES", "AWAY", "GO", "STOP", "PLEASE", "DEAD", "ALIVE", "ALLOW",
	"SHIP", "WAY", "OUTSIDE", "INSIDE", "STAR", "SPACE", "POWER", "CONTROLS", "ESCAPE", "VOID", "MORE", "KILL", "SURVIVE", "ZERO",
	"ONE", "TWO"
]
var unlocked_alien_word_list = ["ME"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlock_word(target_word):
	if unlocked_alien_word_list.find(target_word) == -1:
		unlocked_alien_word_list.append(target_word)
	
