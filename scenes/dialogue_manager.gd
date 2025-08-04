extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var shop_keeper: CharacterBody2D = $ShopKeeper

var dialoguing: bool = false

func _ready() -> void:
	player.start_speaking.connect(player_start_speak)
	player.stop_speaking.connect(player_stop_speak)
	shop_keeper.start_speaking.connect(shopkeeper_start_speak)
	shop_keeper.stop_speaking.connect(shopkeeper_stop_speak)


func player_start_speak():
	if shop_keeper.speak.speaking:
		shop_keeper.speak.interrupted()
	

func player_stop_speak():
	await get_tree().create_timer(randf_range(1.2, 2.5)).timeout
	if not player.speak.speaking:
		dialoguing = true
		shop_keeper.speak.start_speak(randf_range(2.0, 4.0))
	
	
func shopkeeper_start_speak():
	pass
	

func shopkeeper_stop_speak():
	pass
