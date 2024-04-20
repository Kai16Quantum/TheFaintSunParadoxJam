extends RichTextLabel

var queued_for_deletion = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("show_text", self, "on_show_text")
	visible_characters = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_show_text(flags):
	var new_text = flags[0]
	var audio = flags[1]
	
	queued_for_deletion = false
	hide()
	visible_characters = -1
	text = new_text
	$Timer.start()


func _on_timer_timeout() -> void:
	show()
	visible_characters += 1
	if visible_characters < len(text):
		$Timer.start()
	elif !queued_for_deletion:
		$DeleteTimer.start()
		queued_for_deletion = true
	

func _on_delete_timer_timeout() -> void:
	text = ""
	queued_for_deletion = false
