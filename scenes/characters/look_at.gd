extends Node2D

@onready var assets: Node2D = $"../Assets"

var target: Node2D = null
var facing: bool = false
var look_ahead: bool = false
var directional_switch: float = 1.0
var locked_look = false

func _process(delta: float) -> void:
	if look_ahead:
		var direction = Vector2(directional_switch, -1)
		if owner.velocity.length() < 20:
			owner.eyes_lid.position = lerp(owner.eyes_lid.position, 7*(direction).normalized()*Vector2(sign(assets.scale.x), 1), 0.1)
		else:
			owner.eyes_lid.position = lerp(owner.eyes_lid.position, 7*(owner.velocity).normalized()*Vector2(sign(assets.scale.x), 1), 0.1)
		return
	
	if not target == null:
		owner.eyes_lid.position = lerp(owner.eyes_lid.position, 7*(owner.eyes_lid.global_position.direction_to(target.eyes_lid.global_position)).normalized()*Vector2(sign(assets.scale.x), 1), 0.1)
		if facing:
			assets.scale.x = owner.animation_director.facing_scale_factor*sign(owner.position.x - target.position.x)


func look_up():
	target = null
	owner.eyes_lid.position = Vector2(0, -7)
	locked_look = true
	
func look_down():
	target = null
	owner.eyes_lid.position = Vector2(0, 7)
	locked_look = true
	
	
func set_target(new_target):
	if locked_look:
		return
	target = new_target


func start_face(face_target: Node2D):
	set_target(face_target)
	facing = true
	look_ahead = false
	
	
func stop_face():
	facing = false


func _on_timer_timeout() -> void:
	directional_switch = -directional_switch
