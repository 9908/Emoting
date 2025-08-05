extends CharacterBody2D
class_name Chara

@onready var eyes_lid: Sprite2D = $Assets/Eyes/EyesLid
@onready var lookat: Node2D = $LookAt
@onready var speak: Node2D = $Speak
@onready var animation_director: Node2D = $AnimationDirector
@onready var detect_nearby: Area2D = $DetectNearby

@export var speed: float = 400.0
var bump_velocity: Vector2 = Vector2.ZERO

signal start_speaking
signal stop_speaking
signal bowed
signal reached_target

var target_pos = null


func walk_to(new_pos: Node2D):
	target_pos = new_pos
	
	
func bump(character):
	bump_velocity = 700*character.global_position.direction_to(global_position)


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if not target_pos == null:
		direction = global_position.direction_to(target_pos.global_position).normalized()
		if global_position.distance_squared_to(target_pos.global_position) < 50.0:
			target_pos = null
			reached_target.emit()

	velocity = direction * speed * delta * 60 + bump_velocity
	bump_velocity = lerp(bump_velocity, Vector2.ZERO, 0.05)
	move_and_slide()


func stop():
	target_pos = null

func _on_detect_nearby_body_exited(body: Node2D) -> void:
	return
	#if body.is_in_group("chara"):
		#lookat.set_target(null)


func _on_detect_nearby_body_entered(body: Node2D) -> void:
	if body.is_in_group("chara"):
		lookat.set_target(body)
		
		
func _on_bump_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		bumped_by(body)


func bumped_by(body):
	body.bump(self)
