extends Chara

var can_greet_player: bool = false
var greeting_player: bool = false
var cancel_walk_routine: bool = false

func _on_detect_nearby_body_entered(body: Node2D) -> void:
	if body.is_in_group("chara"):
		lookat.set_target(body)
		
	if body == Globals.player and can_greet_player:
		Globals.discussion_manager.customers.greet_player(self)
		Globals.player.lookat.set_target(self)


func check_surroundings():
	if detect_nearby.overlaps_body(Globals.player):
		_on_detect_nearby_body_entered(Globals.player)
		

func bumped_by(body):
	if body == Globals.player:
		body.bump(self)
		self.bump(body)
		Globals.shop_keeper.speak.interrupted()
