extends Node2D

@onready var customer_positions: Node2D = $CustomerPositions
@onready var customers_list: Node2D = $CustomersList
var customer_scn: PackedScene = preload("res://scenes/characters/customer.tscn")
@onready var entry: Marker2D = $Entry
@onready var entry_entrance: Marker2D = $EntryEntrance
var player_bowed: bool = false
var customer_number_before_break: int = 5

func start():
	pop_customer()
	
	await get_tree().create_timer(25.0).timeout
	
	while true:
		pop_customer()
		var waiting_time = randf_range(9.0, 14.0)
		if customer_number_before_break == 0:
			customer_number_before_break = randi_range(3, 5)
			waiting_time = 40.0
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
	for i in range(0, randi_range(2,5)):
		if new_customer.cancel_walk_routine: 
			new_customer.cancel_walk_routine = false
			return
		new_customer.walk_to(customer_positions.get_child(randi_range(0,customer_positions.get_child_count()-1)))
		
		await new_customer.reached_target
		if new_customer.cancel_walk_routine: 
			new_customer.cancel_walk_routine = false
			return
		await get_tree().create_timer(randf_range(1.0,1.5)).timeout
		
	if new_customer.cancel_walk_routine: 
		new_customer.cancel_walk_routine = false
		return
	new_customer.walk_to(entry_entrance)
	
	await new_customer.reached_target
	if new_customer.cancel_walk_routine: 
		new_customer.cancel_walk_routine = false
		return
	
	await get_tree().create_timer(randf_range(1.0,1.5)).timeout
	if new_customer.cancel_walk_routine: 
		new_customer.cancel_walk_routine = false
		return
		
	new_customer.walk_to(entry)
	
	get_tree().create_tween().tween_property(new_customer, "modulate:a", 0.0, 2.0)
	await get_tree().create_timer(2.0).timeout
	new_customer.queue_free()


func cancel_walk_routine(customer):
	customer.cancel_walk_routine = true
	customer.reached_target.emit()

	
func greet_player(customer):
	customer.greeting_player = true
	cancel_walk_routine(customer)
	customer.lookat.start_face(Globals.player)
	customer.animation_director.bow_start()
	customer.stop()
	customer.speak.start_speak(randf_range(2.0, 4.0))
	start_fail_timer(customer)
	player_bowed = false
	
	await Globals.player.bowed
	if is_instance_valid(customer):
		if customer.greeting_player:
			player_bowed = true
			resume_walk(customer)
	

func start_fail_timer(customer):
	await get_tree().create_timer(3.25).timeout
	if not player_bowed:
		Globals.shop_keeper.speak.interrupted()
		customer.speak.interrupted()
		resume_walk(customer)


func resume_walk(customer):
	customer.animation_director.bow_end()
	customer.greeting_player = false
	customer.can_greet_player = false
	customer.lookat.stop_face()
	await get_tree().create_timer(2.0).timeout
	customer.cancel_walk_routine = false
	walk_routine(customer)
		
