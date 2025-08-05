extends ColorRect


func _ready() -> void:
	modulate.a = 0
	Globals.flash = self
	

func flash():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", .2, 0.1)
	tween.tween_property(self, "modulate:a", .0, 0.1)
