extends Node2D

@onready var eyes: AnimatedSprite2D = $"../Assets/Eyes/Eyes"
@onready var eyes_lid: Sprite2D = $"../Assets/Eyes/EyesLid"

var anger_level: float = 0.0
var MAX_ANGER_LEVEL: float = 5.0
var happy: bool = false
@onready var chill_timer: Timer = $ChillTimer

func add_anger_level():
	anger_level += 1.0
	Globals.flash.flash()
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

	if anger_level == MAX_ANGER_LEVEL - 1:
		owner.animation_director.set_about_to_rage(true)
	else:
		owner.animation_director.set_about_to_rage(false)


func set_happy(new_val: bool):
	if new_val:
		if happy:
			eyes.frame = 1
			eyes_lid.hide()
			eyes.position.y = 0
		else:
			eyes.frame = 0
			eyes_lid.show()
			eyes.position.y = 7
		happy = true
		eyes.animation = "happy"
	else:
		happy = false
		eyes.animation = "default"
		eyes_lid.show()
		eyes.position.y = 0
		

func rage():
	Globals.main.game_over()


func _on_chill_timer_timeout() -> void:
	lower_anger_level()


func _on_speak_got_interrupted() -> void:
	add_anger_level()
