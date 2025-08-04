extends ColorRect

var target_alpha: float = 1.0

func _ready() -> void:
	Globals.fade = self

func fade(new_target_alpha: float = 1.0, time: float = 1.0, color_new: Color = Color.BLACK):
	target_alpha = new_target_alpha
	color = color_new
	get_tree().create_tween().tween_property(self, "modulate:a", target_alpha, time)
