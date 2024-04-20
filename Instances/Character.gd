extends GridInstance

signal show_selection_tile(target_global_coord)
signal stopped_walking()

var target_light_scale = Vector2(randf_range(0.95,1.05),randf_range(0.95,1.05))
var spike_trap_amount = 0;
var decoy_trap_amount = 0;
var explosive_trap_amount = 0;
#var spike_scene = preload()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.subscribe("show_interactable", self, "on_show_interactable")
	EventBus.subscribe("hide_interactable", self, "on_hide_interactable")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PointLight2D.scale = lerp($PointLight2D.scale, target_light_scale,0.1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		$InteractSprite.hide()
		if is_instance_valid(target_interactable):
			target_interactable.interact()
			target_interactable = null
	if event.is_action_pressed("trap_menu"):
		$TrapMenu.show()

func move_action(walk_array):
	emit_signal("show_selection_tile",get_parent().get_parent().get_parent().get_global_position_from_tile(walk_array[-1])) 
	# SI ME DA TIEMPO LO CAMBIO LO PROMETO

func on_show_interactable(new_interactable):
	target_interactable = new_interactable
	$InteractSprite.show()

func on_hide_interactable(old_interactable):
	target_interactable = null
	$InteractSprite.hide()

func after_walk():
	emit_signal("stopped_walking")


func _on_light_timer_timeout() -> void:
	target_light_scale = float(health)/float(max_health)*Vector2(randf_range(0.95,1.05),randf_range(0.95,1.05))

func use_trap(trap_scene):
	pass


func _on_trap_pressed() -> void:
	spike_trap_amount = max(0,spike_trap_amount-1)
	#use_trap(


func _on_decoy_pressed() -> void:
	decoy_trap_amount = max(0,decoy_trap_amount-1)


func _on_explosive_pressed() -> void:
	explosive_trap_amount = max(0,explosive_trap_amount-1);
