extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var asset: AnimatedSprite2D = $Asset

var velocity: Vector2 
var time: float = 0

func _ready() -> void:
	velocity = Vector2(randf_range(-25, 25), randf_range(-30, -50))
	scale = randf_range(0.75, 1.5)*Vector2.ONE
	
	
func _process(delta: float) -> void:
	position += velocity*delta + Vector2(25*sin(time*5), 0)*delta
	time += delta
	


func _on_timer_timeout() -> void:
	animation_player.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	free_bubble()
	
	
func free_bubble():
	queue_free()
	
	
func pop():
	asset.play("explode")


func _on_asset_animation_finished() -> void:
	free_bubble()
