extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var shop_keeper: CharacterBody2D = $ShopKeeper
@onready var broom: Node2D = $"../Broom"
@onready var customers: Node2D = $"../Customers"
@onready var current_money: Node2D = $"../CurrentMoney"
@onready var label: Label = $Label

var dialoguing: bool = false
var has_bowed: bool = false
var started_customers: bool = false
var discussion_streak: int = 0

func _ready() -> void:
	Globals.discussion_manager = self
	player.start_speaking.connect(player_start_speak)
	player.bowed.connect(player_bowed)
	player.stop_speaking.connect(player_stop_speak)
	shop_keeper.start_speaking.connect(shopkeeper_start_speak)
	shop_keeper.stop_speaking.connect(shopkeeper_stop_speak)

func _process(delta: float) -> void:
	label.text = str(discussion_streak)
	
	
func player_start_speak():
	if Globals.shop_keeper.can_greet_player and not Globals.shop_keeper.greeting_player:
		shop_keeper.speak.interrupted()
		return
		
	if shop_keeper.speak.speaking:
		shop_keeper.speak.interrupted()

func set_speak_color(new_color: Color):
	player.speak.color_speak = new_color
	shop_keeper.speak.color_speak = new_color
	
	
func reset_color():
	player.speak.reset_color()
	shop_keeper.speak.reset_color()
	

func player_stop_speak():
	if not Globals.shop_keeper.can_greet_player:
		await get_tree().create_timer(randf_range(1.2, 2.5)).timeout
		if not player.speak.speaking and customers.customers_list.get_child_count() == 0:
			dialoguing = true
			shop_keeper.speak.start_speak(randf_range(2.0, 4.0))


func lower_price():
	broom.show_price(true)
	await get_tree().create_timer(1.0).timeout
	broom.set_price(0.0)
	current_money.broom_price_lowered()
	

func player_bowed():
	if not has_bowed:
		has_bowed = true
		#await get_tree().create_timer(randf_range(1.2, 2.5)).timeout
		shop_keeper.lookat.start_face(player)
		#shop_keeper.animation_director.bow()
	shop_keeper.anger_level.lower_anger_level()
	
	
func shopkeeper_start_speak():
	if not Globals.shop_keeper.can_greet_player:
		discussion_streak += 1
		set_speak_color(Color.GREEN_YELLOW.lightened(1.0-(discussion_streak)/2.0))
	
	if discussion_streak >= 2:
		shop_keeper.anger_level.set_happy(true)
		if not started_customers:
			started_customers = true
			await get_tree().create_timer(2.0).timeout
			customers.start()
	
	if discussion_streak == 3:
		lower_price()
	

func shopkeeper_stop_speak():
	shop_keeper.lookat.stop_face()
