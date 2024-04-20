extends Sprite2D
class_name GridInstance

var target_interactable = null
var walk_array = []
var next_point = null
var my_tile_position = position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tile_map_clicked_tile(relative_cell: Variant) -> void:
	move_to_tile(relative_cell)

func move_to_tile(relative_cell):
	my_tile_position = get_tile_position()
	var path = Global.astargrid.get_point_path(my_tile_position, relative_cell)
	if Global.astargrid && len(path)>1:
		#global_position = get_parent().get_global_position_from_tile(relative_cell)
		walk_array = Array(path)
		walk() #ugly
		$Walk.start()
		move_action(walk_array)

func move_action(walk_array):
	pass

func get_tile_position():
	return get_parent().get_parent().get_parent().get_inst_tile(self) # COSAS DE LA JAM!!!! :·)

func _on_walk_timeout() -> void:
	walk()
	if len(walk_array) > 0:
		$Walk.start()
	else:
		after_walk()

func after_walk():
	pass

func walk():
	my_tile_position = get_tile_position()
	if len(walk_array) > 0:
		next_point = walk_array.pop_front()
		var pos_tween = create_tween()
		var next_pos = get_parent().get_parent().get_parent().get_global_position_from_tile(next_point) # Y ME LA SUDAAA!
		pos_tween.tween_property(self, "global_position", Vector2(next_pos), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		print(next_pos)
	else:
		after_walk()


