extends CharacterBody2D
class_name Chara

@onready var eyes_lid: Sprite2D = $Assets/Eyes/EyesLid
@onready var look_at: Node2D = $LookAt
@onready var speak: Node2D = $Speak
@onready var animation_director: Node2D = $AnimationDirector

signal start_speaking
signal stop_speaking

func _on_detect_nearby_body_entered(body: Node2D) -> void:
	if body.is_in_group("chara"):
		look_at.set_target(body)


func _on_detect_nearby_body_exited(body: Node2D) -> void:
	return
	#if body.is_in_group("chara"):
		#look_at.set_target(null)


func _on_bump_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		bumped_by(body)


func bumped_by(body):
	body.bump(self)
