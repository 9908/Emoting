extends Node2D

signal got_interrupted

var bubble_scn = preload("res://scenes/VFX/Bubble.tscn")
@onready var timer_bubble: Timer = $TimerBubble
var speaking: bool = false
var bubbles: Array
var color_speak: Color = Color.WHITE
var current_color_speak = color_speak

func start_speak(speach_time: float = 0.0):
	if speaking:
		return
	current_color_speak = color_speak
	owner.animation_director.mouth.show()
	timer_bubble.start(0.1)
	speaking = true
	owner.start_speaking.emit()
	if not speach_time == 0.0:
		await get_tree().create_timer(speach_time).timeout
		if speaking:
			stop_speak()


func reset_color():
	color_speak = Color.WHITE
	current_color_speak = color_speak


func stop_speak():
	if not speaking:
		return
	owner.animation_director.mouth.hide()
	timer_bubble.stop()
	speaking = false
	owner.stop_speaking.emit()
	
	
func interrupted():
	got_interrupted.emit()
	stop_speak()
	
	owner.anger_level.set_happy(false)
	Globals.discussion_manager.discussion_streak = 0
	Globals.discussion_manager.reset_color()
	
	for bubble in bubbles:
		if not bubble == null:
			bubble.pop()
			await get_tree().create_timer(.075).timeout


func _on_timer_bubble_timeout() -> void:
	if speaking:
		timer_bubble.start(randf_range(0.15, .75))
		var new_bubble = bubble_scn.instantiate()
		new_bubble.modulate = current_color_speak
		Globals.main.add_child(new_bubble)
		new_bubble.global_position = owner.eyes_lid.global_position
		bubbles.append(new_bubble)
