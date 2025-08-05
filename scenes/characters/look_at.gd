extends Node2D

@onready var assets: Node2D = $"../Assets"

var target: Node2D = null
var facing: bool = false
var facing_scale_factor: float = 1.0

func _process(delta: float) -> void:
	if not target == null:
		owner.eyes_lid.position = lerp(owner.eyes_lid.position, 7*(owner.eyes_lid.global_position.direction_to(target.eyes_lid.global_position)).normalized()*Vector2(sign(assets.scale.x), 1), 0.1)
		if facing:
			assets.scale.x = facing_scale_factor*sign(owner.position.x - target.position.x)


func look_up():
	target = null
	owner.eyes_lid.position = Vector2(0, -7)
	
	
func set_target(new_target):
	target = new_target


func start_face(face_target: Node2D, scale_factor: float = 1.0):
	set_target(face_target)
	facing_scale_factor = scale_factor
	facing = true

func stop_face():
	facing = false
