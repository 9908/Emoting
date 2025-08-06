extends Marker2D

func _ready():
	Globals.shop_keeper_target = self
	global_position = Globals.shop_keeper.global_position
