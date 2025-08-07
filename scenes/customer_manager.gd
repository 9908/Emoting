extends Node2D

@onready var customer_positions: Node2D = $CustomerPositions
@onready var customers_list: Node2D = $CustomersList
var customer_scn: PackedScene = preload("res://scenes/characters/customer.tscn")
@onready var entry: Marker2D = $Entry
@onready var entry_entrance: Marker2D = $EntryEntrance
var player_bowed: bool = false
var customer_number_before_break: int = 1

func _ready() -> void:
	Globals.customers = customers_list
	Globals.customer_manager = self


func start():
	while true:
		pop_customer()
		var waiting_time = 11.0
		if customer_number_before_break == 0:
			customer_number_before_break = 1
			waiting_time = 45.0
		await get_tree().create_timer(waiting_time).timeout
		

func pop_customer():
	customer_number_before_break -= 1
	var new_customer = customer_scn.instantiate()
	customers_list.add_child(new_customer)
	new_customer.global_position = entry.global_position
	new_customer.modulate.a = 0.0
	get_tree().create_tween().tween_property(new_customer, "modulate:a", 1.0, 2.0)
	await get_tree().create_timer(3.0).timeout
	new_customer.walk_to(entry_entrance)
	await new_customer.reached_target
	walk_routine(new_customer)
	new_customer.can_greet_player = true
	new_customer.check_surroundings()
	

func walk_routine(new_customer):
	new_customer.lookat.look_ahead = true
	for i in 3:
		if new_customer.cancel_walk_routine: return
		#print("WALK --- A " + str(i))
		var new_position = customer_positions.get_child(randi_range(0,customer_positions.get_child_count()-1))
		while new_position.global_position.distance_squared_to(new_customer.global_position) < 50.0:
			new_position = customer_positions.get_child(randi_range(0,customer_positions.get_child_count()-1))
		new_customer.walk_to(new_position)
		
		await new_customer.reached_target
		if new_customer.cancel_walk_routine: return
		await get_tree().create_timer(2.0).timeout
		
	if new_customer.cancel_walk_routine: return
	#print("WALK --- B ")
	new_customer.walk_to(entry_entrance)
	
	await new_customer.reached_target
	if new_customer.cancel_walk_routine: return
	
	await get_tree().create_timer(1.0).timeout
	if new_customer.cancel_walk_routine: return
		
	#print("WALK --- C ")
	new_customer.walk_to(entry)
	
	get_tree().create_tween().tween_property(new_customer, "modulate:a", 0.0, 2.0)
	await get_tree().create_timer(2.0).timeout
	new_customer.queue_free()


func cancel_walk_routine(customer):
	customer.cancel_walk_routine = true
	customer.reached_target.emit()
	customer.lookat.look_ahead = false

	
func greet_player(customer):
	customer.greeting_player = true
	if customer.is_in_group("customer"):
		cancel_walk_routine(customer)
	customer.lookat.start_face(Globals.player)
	customer.animation_director.bow_start()
	customer.stop()
	#customer.speak.start_speak(randf_range(2.0, 4.0))
	start_fail_timer(customer)
	player_bowed = false
	
	await Globals.player.bowed
	await get_tree().create_timer(1.0).timeout
	if is_instance_valid(customer):
		if customer.greeting_player:
			player_bowed = true
			customer.eyes.animation = "happy"
			customer.eyes.frame = 1
			customer.eyes_lid.hide()
			resume_walk(customer)
			if customer == Globals.shop_keeper:
				Globals.shop_keeper.can_greet_player = false
	

func start_fail_timer(customer):
	await get_tree().create_timer(3.25).timeout
	if not player_bowed:
		Globals.shop_keeper.speak.interrupted()
		#customer.speak.interrupted()
		resume_walk(customer)
		if customer == Globals.shop_keeper:
			await get_tree().create_timer(2.0).timeout
			if not customer.greeting_player:
				greet_player(Globals.shop_keeper)


func resume_walk(customer):
	customer.animation_director.bow_end()
	customer.greeting_player = false
	if customer.is_in_group("customer"):
		customer.can_greet_player = false
		customer.lookat.stop_face()
		customer.lookat.look_ahead = true
	await get_tree().create_timer(1.0).timeout
	customer.eyes.animation = "default"
	customer.eyes_lid.show()
	await get_tree().create_timer(1.0).timeout
	if customer.is_in_group("customer"):
		customer.cancel_walk_routine = false
		walk_routine(customer)
			
