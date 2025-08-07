extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var assets: Node2D = $"../Assets"
@onready var mouth: AnimatedSprite2D = $"../Assets/Eyes/Mouth"
@onready var eyes: AnimatedSprite2D = $"../Assets/Eyes/Eyes"

@onready var vibrate: AnimationPlayer = $Vibrate

var playing_custom_animation: bool = false
@export var facing_scale_factor: float = 1.0

func _ready() -> void:
	mouth.hide()


func _process(delta: float) -> void:
	if not playing_custom_animation:
		if owner.velocity.length() < 20:
			animation_player.play("Idle")
		else:
			animation_player.play("Walk")
	
	if not owner.velocity.x == 0 and owner.velocity.length() > 20:
		assets.scale.x = -facing_scale_factor*sign(owner.velocity.x)
		
		
func set_about_to_rage(new_val):
	if new_val:
		vibrate.play("about_to_rage")
	else:
		vibrate.play("RESET")

	
func bow():
	if playing_custom_animation: 
		return
	
	playing_custom_animation = true
	animation_player.play("Bow")
	owner.bowed.emit()


func bow_start():
	if playing_custom_animation: 
		return
	
	playing_custom_animation = true
	animation_player.play("BowStart")
	owner.bowed.emit()
	
	
func bow_end():
	if not playing_custom_animation: 
		return
	
	animation_player.play("BowEnd")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bow" or anim_name == "BowEnd":
		playing_custom_animation = false
