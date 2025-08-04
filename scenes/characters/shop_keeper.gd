extends Chara

@onready var anger_level: Node2D = $AngerLevel

func _ready() -> void:
	Globals.shop_keeper = self


func bumped_by(body):
	body.bump(self)
	anger_level.add_anger_level()
	speak.interrupted()
