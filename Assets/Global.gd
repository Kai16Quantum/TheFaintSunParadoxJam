extends Node

var astargrid
var alien_word_list = [
	"ME", "YOU", "RUN", "FIGHT", "HELP", "NO", "AWAY", "GO", "PLEASE", "DEAD", "ALIVE", "ALLOW",
	"SHIP", "WAY", "PLANT", "INSIDE", "STAR", "SPACE", "POWER", "CONTROLS", "ESCAPE", "VOID", "MORE", "KILL", "SURVIVE", "ZERO"
]
var unlocked_alien_word_list = ["ME","YOU","NO","PLEASE"]
var restart_count = 0
var used_dialogues = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func unlock_word(target_word):
	if unlocked_alien_word_list.find(target_word) == -1:
		unlocked_alien_word_list.append(target_word)
		EventBus.publish("unlocked_word", target_word)

func use_dialogue(dialogue_name):
	if !(dialogue_name in used_dialogues):
		used_dialogues.append(dialogue_name)
