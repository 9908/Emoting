extends Node2D

@onready var assets: Node2D = $"../Assets"

var target: Node2D = null

func _process(delta: float) -> void:
	if not target == null:
		owner.eyes_lid.position = lerp(owner.eyes_lid.position, 7*(owner.eyes_lid.global_position.direction_to(target.eyes_lid.global_position)).normalized()*Vector2(sign(assets.scale.x), 1), 0.1)


func set_target(new_target):
	target = new_target
