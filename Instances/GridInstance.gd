extends Sprite2D
class_name GridInstance

var target_interactable = null
var walk_array = []
var next_point = null
var my_tile_position: Vector2i = position
var starting_tile = Vector2i.ZERO
var attack_cooldown = false
@export var max_health: int = 3
var dead = false
@export var breakable_decor = false
@onready var health: int = max_health
@export var move_delay = 0.2
@onready var default_sprite_region = $Sprite.texture.region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var parent = get_parent().get_parent().get_parent()
	var my_tile = parent.get_tile_from_position(position)
	var my_position = parent.get_global_position_from_tile(my_tile)
	move_to_tile(my_tile)
	starting_tile = get_tile_position()
	ready()

func ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tile_map_clicked_tile(relative_cell: Variant) -> void:
	move_to_tile(relative_cell)

func move_to_tile(relative_cell):
	my_tile_position = get_tile_position()
	var Astar = Global.astargrid
	if Astar:
		var path = Astar.get_point_path(my_tile_position, relative_cell)
		if Global.astargrid && len(path)>1:
			#global_position = get_parent().get_global_position_from_tile(relative_cell)
			walk_array = Array(path)
			walk_array.pop_front() # Remove my tile.
			walk() #ugly
			$Walk.start(move_delay)

func move_action(walk_array):
	pass

func change_sprite(string_name : String):
	var my_atlas = $Sprite.texture
	if !dead && !breakable_decor:
		match string_name:
			"Attack":
				my_atlas.region.position = default_sprite_region.position + Vector2(10,0)
			"Damaged":
				my_atlas.region.position = default_sprite_region.position + Vector2(20,0)
			"Dead":
				my_atlas.region.position = default_sprite_region.position + Vector2(30,0)
			_:
				my_atlas.region.position = default_sprite_region.position

func collide_with_entity(entity):
	if !dead && !breakable_decor:
		walk_array.insert(0,entity.my_tile_position)
		if entity.is_in_group("Player") && self.is_in_group("Enemy"):
			melee_attack(entity)
		elif entity.is_in_group("Enemy") && self.is_in_group("Player"):
			melee_attack(entity)

func melee_attack(instance):
	if !attack_cooldown:
		$AttackSFX.play()
		attack_cooldown = true
		$AnimationPlayer.play("melee")
		instance.take_damage(1)
		$AttackCooldown.start()


func take_damage(damage_amount):
	if !dead:
		$AnimationPlayer.play("take_damage")
		var new_health = health-damage_amount
		health = max(0,new_health)
		take_damage_action()
		$Sprite.material.set("shader_parameter/active", true)
		$HitShaderTimer.start()
		if new_health <= 0:
			dead_action()
			change_sprite("Dead")
			dead = true
			walk_array = []
			if !breakable_decor:
				EventBus.publish("add_blood_splatter", [my_tile_position,damage_amount])

func dead_action():
	pass

func take_damage_action():
	pass

func talk(talk_string, talk_audio = null):
	if (talk_string != ""):
		EventBus.publish("show_text", [[talk_string], talk_audio, is_in_group("Enemy")])

func check_if_moving_into_instance():
	var groups = ["Player", "Enemy"]
	var colliding_entity = null
	if (next_point):
		for group_name in groups:
			for inst in get_tree().get_nodes_in_group(group_name):
				if inst != self && inst.dead == false:
					if Vector2i(next_point) == Vector2i(inst.my_tile_position):
						colliding_entity = inst
	return colliding_entity

func get_instances_in_group_area(group_name):
	var areas_overlap = $CheckInstancesBox.get_overlapping_areas()
	var enemy_array = []
	for area in areas_overlap:
		var inst = area.get_parent()
		if inst.is_in_group(group_name):
			enemy_array.append(inst)
	return enemy_array

func get_tile_position():
	return get_parent().get_parent().get_parent().get_inst_tile(self) # COSAS DE LA JAM!!!! :·)

func _on_walk_timeout() -> void:
	if len(walk_array) > 0:
		$Walk.start(move_delay)
	else:
		my_tile_position = get_tile_position()
		after_walk()
	check_if_moving_into_instance()
	walk()

func after_walk():
	pass

func walk():
	if !dead && !breakable_decor:
		my_tile_position = get_tile_position()
		if len(walk_array) > 0:
			move_action(walk_array)
			next_point = walk_array.pop_front()
			
			#Let's check if the next point is an instance
			var inst_collide = check_if_moving_into_instance()
			if !inst_collide:
				$AnimationPlayer.play("move")
				$WalkSFX.play()
				var pos_tween = create_tween()
				var next_pos = get_parent().get_parent().get_parent().get_global_position_from_tile(next_point) # Y ME LA SUDAAA!
				pos_tween.tween_property(self, "global_position", Vector2(next_pos), 0.1).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
			else: 
				collide_with_entity(inst_collide)
		else:
			after_walk()




func _on_attack_cooldown_timeout() -> void:
	attack_cooldown = false


func _on_hit_shader_timer_timeout() -> void:
	$Sprite.material.set("shader_parameter/active", false)
