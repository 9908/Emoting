extends Chara

@onready var anger_level: Node2D = $AngerLevel
var tick_timer: float = 0.1
var is_talking_to_customer: bool = false
var current_customer_discussion = null

func _ready() -> void:
	Globals.shop_keeper = self
	Globals.player.start_speaking.connect(player_interrupted_discussion)
	Globals.player.bumped.connect(player_interrupted_discussion)


func bumped_by(body):
	body.bump(self)
	speak.interrupted()


func _physics_process(delta):
	super(delta)
	if Globals.customers.get_child_count() > 0:
		tick_timer -= delta
		if tick_timer < 0:
			tick_timer = randf_range(.5, 1.2)
			var closest_customer = null
			var closest_distance = 999999
			for customer in Globals.customers.get_children():
				if customer.position.y < closest_distance:
					closest_distance = customer.position.y
					closest_customer = customer
			Globals.shop_keeper_target.global_position.x = closest_customer.global_position.x
			walk_to(Globals.shop_keeper_target)
			lookat.set_target(closest_customer)
	else:
		lookat.set_target(Globals.player)


# Discussion customer-shopkeeper
func _on_customer_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("customer"):
		var body = area.owner
		if not body.has_talked_to_shopkeeper and not is_talking_to_customer:
			body.can_greet_player = false
			is_talking_to_customer = true
			current_customer_discussion = body
			body.has_talked_to_shopkeeper = true
			Globals.customer_manager.cancel_walk_routine(body)
			body.stop()
			body.lookat.look_up()
			lookat.look_down()
			get_tree().create_tween().tween_property(body, "position:y", body.position.y - 30.0, 1.0)
			await get_tree().create_timer(1.5).timeout
			if not is_talking_to_customer: return
			body.speak.start_speak(1.5)
			await get_tree().create_timer(2.5).timeout
			if not is_talking_to_customer: return
			speak.start_speak(1.5, false)
			await get_tree().create_timer(2.5).timeout
			if not is_talking_to_customer: return
			body.speak.start_speak(1.5)
			Globals.customer_manager.resume_walk(body)
			body.lookat.locked_look = false
			lookat.locked_look = false
			is_talking_to_customer = false
			

func player_interrupted_discussion():
	if not is_talking_to_customer:
		return
	is_talking_to_customer = false
	current_customer_discussion.speak.interrupted()
	speak.interrupted()
	current_customer_discussion.lookat.locked_look = false
	lookat.locked_look = false
	current_customer_discussion.lookat.set_target(Globals.player)
	lookat.set_target(Globals.player)
	await get_tree().create_timer(1.5).timeout
	Globals.customer_manager.resume_walk(current_customer_discussion)
