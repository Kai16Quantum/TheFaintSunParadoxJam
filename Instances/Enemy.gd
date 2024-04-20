extends GridInstance

var target_instance = null

func after_walk():
	#Check if there are enemies there.
	pass

func _on_shoot_button_pressed() -> void:
	EventBus.publish("tried_to_shoot", self)


func _on_shoot_button_mouse_entered() -> void:
	EventBus.publish("hovering_shot")
