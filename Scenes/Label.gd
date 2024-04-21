extends RichTextLabel

var queued_for_deletion = false
@export var enemy_text : bool = false
var string_array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("show_text", self, "on_show_text")
	visible_characters = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_show_text(flags):
	var new_text_array = flags[0]
	var audio = flags[1]
	var enemy = flags[2]
	if (enemy_text == enemy):
		string_array = new_text_array
		get_next_text()
		if audio is AudioStream:
			get_parent().get_node("VA").stream = audio
			get_parent().get_node("VA").play()

func get_next_text():
	if len(string_array) > 0:
		text = string_array.pop_front()
		if enemy_text:
			text_to_alien()
		queued_for_deletion = false
		hide()
		visible_characters = -1
		$Timer.start()
		$DeleteTimer.stop()

func text_to_alien():
	var alien_words = text.split(' ', false)
	var new_text = ""
	for word in alien_words:
		var index = Global.alien_word_list.find(word)
		var resource_location = "res://Sprites/Words/Word"+str(index)+".png"
		if Global.unlocked_alien_word_list.find(word) != -1:
			new_text += word+" "
		else:
			if resource_location:
				new_text += "[img={7}x{7}]%s[/img]" % resource_location + " "
	text = new_text

func _on_timer_timeout() -> void:
	
	show()
	visible_characters += 1
	var my_sound_n = clamp(visible_characters, 0, len(get_parsed_text())-1)
	if (text[my_sound_n] not in [","," "]) && (my_sound_n != len(get_parsed_text())-1):
		$LetterSound.play()
	if visible_characters < len(text):
		$Timer.start()
	elif len(string_array) >= 1:
		$NextTextTimer.start()
	elif !queued_for_deletion:
		$DeleteTimer.start()
		queued_for_deletion = true
	

func _on_delete_timer_timeout() -> void:
	text = ""
	queued_for_deletion = false


func _on_next_text_timer_timeout() -> void:
	get_next_text()
