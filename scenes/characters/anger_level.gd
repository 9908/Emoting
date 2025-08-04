extends Node2D

@onready var eyes: AnimatedSprite2D = $"../Assets/Eyes/Eyes"
var anger_level: float = 0.0
var MAX_ANGER_LEVEL: float = 5.0
@onready var chill_timer: Timer = $ChillTimer

func add_anger_level():
	anger_level += 1.0
	set_eye_color()
	if anger_level >= MAX_ANGER_LEVEL:
		rage()


func lower_anger_level():
	if anger_level > 0:
		anger_level -= 1.0
		set_eye_color()


func set_eye_color():
	var modu_var = 1.0-anger_level/MAX_ANGER_LEVEL
	eyes.modulate = Color.RED.lightened(modu_var)
	eyes.frame = anger_level
	chill_timer.start(4.5)


func rage():
	pass


func _on_chill_timer_timeout() -> void:
	lower_anger_level()


func _on_speak_got_interrupted() -> void:
	add_anger_level()
