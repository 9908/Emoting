extends Node2D

var level = preload("res://scenes/level.tscn")
var gameover = preload("res://scenes/gameover.tscn")
@onready var animation_player: AnimationPlayer = $GameIntro/AnimationPlayer
@onready var game_intro: Node2D = $GameIntro
@onready var controls_label: Label = $Fg/Controls_Label
@onready var game_win: Node2D = $GameWin

var level_in
var gameover_in
var won_game: bool = false

func _ready() -> void:
	Globals.main = self
	controls_label.hide()
	game_win.hide()
	
	#Globals.fade.fade(0, 1.0)
	#game_intro.queue_free()
	#level_in = level.instantiate()
	#add_child(level_in)
	
	await get_tree().create_timer(1.0).timeout
	Globals.fade.fade(0, 2.0)
	await get_tree().create_timer(2.0).timeout
	animation_player.play("intro")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Globals.fade.fade(1, 1.0)
	await get_tree().create_timer(1.0).timeout
	controls_label.show()
	game_intro.queue_free()
	level_in = level.instantiate()
	add_child(level_in)
	await get_tree().create_timer(3.5).timeout
	controls_label.hide()
	Globals.fade.fade(0, 1.0)
	Globals.player.can_be_controlled = true


func game_over():
	if not Globals.player.can_be_controlled:
		return
		
	Globals.player.can_be_controlled = false
	get_tree().create_tween().tween_property(Globals.shop_keeper, "global_position", Globals.player.global_position, 0.5)
	await get_tree().create_timer(0.5).timeout
	gameover_in = gameover.instantiate()
	add_child(gameover_in)
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(level_in):
		level_in.queue_free()
	await get_tree().create_timer(2.5).timeout
	Globals.fade.fade(1, 1.0)
	await get_tree().create_timer(1.0).timeout
	controls_label.show()
	gameover_in.queue_free()
	level_in = level.instantiate()
	add_child(level_in)
	await get_tree().create_timer(1.8).timeout
	Globals.fade.fade(0, 1.0)
	controls_label.hide()
	Globals.player.can_be_controlled = true
