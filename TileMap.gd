extends TileMap

signal clicked_tile(tile_position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("add_blood_splatter",self,"on_add_blood_splatter")
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

func on_add_blood_splatter(flags):
	var target_tile = Vector2i(flags[0])
	var strength = flags[1]
	var splatter_positions = []
	splatter_positions.append(target_tile)
	while strength > 10:
		var random_offset = [Vector2i.UP,Vector2i.DOWN,Vector2i.LEFT,Vector2i.RIGHT].pick_random()
		strength *= 0.5
		splatter_positions.append(target_tile+random_offset)
	var source_id = tile_set.get_source_id(0)
	for splat_pos in splatter_positions:
		var random_splat_tile = [Vector2i(11,5), Vector2i(12,5)].pick_random()
		set_cell(4, splat_pos+get_used_rect().position, source_id, random_splat_tile)

