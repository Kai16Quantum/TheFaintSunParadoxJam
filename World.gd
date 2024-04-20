extends Node2D

@onready var StaticTiles = get_tilemap(1)
@onready var WalkableTiles = get_tilemap(0)
var astargrid = []
var changing_room = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	EventBus.subscribe("move_to_room_direction", self, "on_move_to_room_direction")
	
	astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(1000,1000)
	astargrid.cell_size = Vector2i(1,1)
	astargrid.update()
	
	for solid_tile in StaticTiles:
		astargrid.set_point_solid(solid_tile)
	for solid_object in $Props.get_children():
		var solid_ground = get_tile_from_position(solid_object.global_position)
		astargrid.set_point_solid(solid_ground)
		if solid_object.get("extra_points_relative"):
			if len(solid_object.extra_points_relative) > 0:
				for point in solid_object.extra_points_relative:
					astargrid.set_point_solid(solid_ground+point)
		
	
	Global.astargrid = astargrid

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_tilemap(index):
	var tilemap = $TileMap.get_used_cells(index)
	var return_tilemap = []
	var map_limit = $TileMap.get_used_rect()
	for tile in tilemap:
		return_tilemap.append(tile - map_limit.position)
	return return_tilemap

func get_inst_tile(inst):
	var map_limit = $TileMap.get_used_rect()
	var in_pos = inst.global_position
	var tile = get_tile_from_position(in_pos)
	return tile

func get_tile_from_position(target_position):
	var map_limit = $TileMap.get_used_rect()
	var tile = $TileMap.local_to_map($TileMap.to_local(target_position))
	return tile - map_limit.position

func get_global_position_from_tile(relative_cell):
	var map_limit = $TileMap.get_used_rect()
	var global_pos = (map_limit.position + Vector2i(relative_cell))*Vector2i(10,10) + Vector2i($TileMap.position) + Vector2i(5,5)
	return global_pos


func on_move_to_room_direction(flags):
	var target_position = flags[0]
	var target_direction = flags[1]
	if !changing_room:
		var screen_tween = create_tween()
		screen_tween.tween_property($CurrentScene, "position", 
		target_position, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		#Let's normalize it.
		var normalized_direction = target_direction*2
		var move_direction = Vector2i(normalized_direction.x,normalized_direction.y)
		$Instances/Ally/Player.move_to_tile($Instances/Ally/Player.my_tile_position + move_direction)
		
		$Other/ChangeRoomTimer.start()
		changing_room = true


func _on_change_room_timer_timeout() -> void:
	changing_room = false



func _on_player_show_selection_tile(target_global_coord: Variant) -> void:
	$SelectedTile.global_position = target_global_coord
	$SelectedTile.show()


func _on_player_stopped_walking() -> void:
	$SelectedTile.hide()
