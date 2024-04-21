extends GridInstance

signal show_selection_tile(target_global_coord)
signal stopped_walking()

var target_light_scale = Vector2(randf_range(0.95,1.05),randf_range(0.95,1.05))
var spike_trap_amount = 0;
var decoy_trap_amount = 0;
var explosive_trap_amount = 0;
var bullet_amount = 100
#var spike_scene = preload()


# Called when the node enters the scene tree for the first time.
func ready() -> void:
	EventBus.subscribe("show_interactable", self, "on_show_interactable")
	EventBus.subscribe("hide_interactable", self, "on_hide_interactable")
	EventBus.subscribe("hovering_shot", self, "on_hovering_shot")
	EventBus.subscribe("tried_to_shoot", self, "on_tried_to_shoot")
	EventBus.subscribe("replenish_ammo", self, "on_replenish_ammo")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$PointLight2D.scale = lerp($PointLight2D.scale, target_light_scale,0.1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		$InteractSprite.hide()
		if is_instance_valid(target_interactable):
			$ActivatePopupSFX.play()
			target_interactable.interact(self)
			target_interactable = null
	if event.is_action_pressed("trap_menu"):
		$TrapMenu.show()

func move_action(walk_array):
	emit_signal("show_selection_tile",get_parent().get_parent().get_parent().get_global_position_from_tile(walk_array[-1])) 
	# SI ME DA TIEMPO LO CAMBIO LO PROMETO

func shake_camera(amount):
	EventBus.publish("shake_camera",amount)

func on_show_interactable(new_interactable):
	$PopupSFX.play()
	target_interactable = new_interactable
	$InteractSprite.show()

func on_hide_interactable(old_interactable):
	target_interactable = null
	$InteractSprite.hide()

func after_walk():
	emit_signal("stopped_walking")

func on_hovering_shot(flags):
	if bullet_amount > 0:
		$ShootSprite.show()
		$ShootSprite/HideTimer.start()
		$ShootSprite/Label.text = str(bullet_amount)

func _on_light_timer_timeout() -> void:
	target_light_scale = float(health)/float(max_health)*Vector2(randf_range(0.95,1.05),randf_range(0.95,1.05))

func use_trap(trap_scene):
	pass

func dead_action():
	EventBus.publish("reset_loop", self)

func _on_trap_pressed() -> void:
	spike_trap_amount = max(0,spike_trap_amount-1)
	#use_trap(


func _on_decoy_pressed() -> void:
	decoy_trap_amount = max(0,decoy_trap_amount-1)


func _on_explosive_pressed() -> void:
	explosive_trap_amount = max(0,explosive_trap_amount-1);


func _on_hide_timer_timeout() -> void:
	$ShootSprite.hide()

func on_tried_to_shoot(target_instance):
	if bullet_amount > 0:
		$GunSFX.play()
		target_instance.take_damage(100)
		bullet_amount -= 1
		shake_camera(0.7)
		$ShootSprite/Label.text = str(bullet_amount)

func on_replenish_ammo(flags):
	bullet_amount += 1
