extends TileMap

signal clicked_tile(tile_position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var map_limit = get_used_rect()
			var clicked_cell = local_to_map(get_local_mouse_position())
			var relative_cell = clicked_cell-map_limit.position
			emit_signal("clicked_tile", Vector2i(relative_cell))
