extends Node2D

@export var extra_points_relative: = []
@export var key_word = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open():
	hide()
	EventBus.publish("change_door_status", [self, false])

func close():
	show()
	EventBus.publish("change_door_status", [self, true])

func _on_area_2d_area_entered(area: Area2D) -> void:
	var instance = area.get_parent()
	if instance.is_in_group("Player"):
		if Global.unlocked_alien_word_list.find(key_word) != -1:
			open()
	elif instance.is_in_group("Enemy"):
			open()


func _on_area_2d_area_exited(area: Area2D) -> void:
	var overlap_areas = $Area2D.get_overlapping_areas()
	var overlap_instances = []
	for area_inst in overlap_areas:
		var parent = area_inst.get_parent()
		if parent.is_in_group("Enemy") || parent.is_in_group("Player"):
			overlap_instances.append(parent)
	if len(overlap_instances) == 0:
		close()
