extends Interactable


func activate(player):
	var target_position = $PlayerPosition.global_position
	var parent = get_parent().get_parent() #me niego
	var target_tile = parent.get_tile_from_position(target_position)
	var final_position = parent.get_global_position_from_tile(target_tile)
	player.global_position = final_position
	var camera_position = $CameraPosition.global_position
	EventBus.publish("move_to_position", camera_position)
	
