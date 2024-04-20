extends Sprite2D

var my_tile_position = position
var walk_array = []
var next_point = null

signal show_selection_tile(target_global_coord)
signal stopped_walking()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func move_to_tile(relative_cell):
	my_tile_position = get_tile_position()
	var path = Global.astargrid.get_point_path(my_tile_position, relative_cell)
	if Global.astargrid:
		#global_position = get_parent().get_global_position_from_tile(relative_cell)
		walk_array = Array(path)
		walk()
		$Walk.start()
		emit_signal("show_selection_tile",get_parent().get_global_position_from_tile(walk_array[-1]))


func _on_tile_map_clicked_tile(relative_cell: Variant) -> void:
	move_to_tile(relative_cell)

func get_tile_position():
	return get_parent().get_inst_tile(self)

func _on_walk_timeout() -> void:
	walk()
	if len(walk_array) > 0:
		$Walk.start()
	else:
		emit_signal("stopped_walking")

func walk():
	if len(walk_array) > 0:
		next_point = walk_array.pop_front()
		var pos_tween = create_tween()
		var next_pos = get_parent().get_global_position_from_tile(next_point)
		pos_tween.tween_property(self, "global_position", Vector2(next_pos), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		print(next_pos)
	else:
		emit_signal("stopped_walking")
