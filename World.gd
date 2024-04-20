extends Node2D

@onready var StaticTiles = get_tilemap(1)
@onready var WalkableTiles = get_tilemap(0)
var astargrid = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astargrid = AStarGrid2D.new()
	astargrid.size = Vector2i(1000,1000)
	astargrid.cell_size = Vector2i(1,1)
	astargrid.update()
	
	for solid_tile in StaticTiles:
		astargrid.set_point_solid(solid_tile)
	
	Global.astargrid = astargrid
	$Character.global_position = WalkableTiles[5]


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


func _on_character_show_selection_tile(target_global_coord: Variant) -> void:
	$SelectedTile.global_position = target_global_coord
	$SelectedTile.show()


func _on_character_stopped_walking() -> void:
	$SelectedTile.hide()
