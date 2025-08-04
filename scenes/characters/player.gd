extends Chara

@export var speed: float = 400.0
var bump_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	Globals.player = self
	

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if not animation_director.playing_custom_animation and bump_velocity.length() < 100:
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		elif Input.is_action_pressed("ui_left"):
			direction.x -= 1
			
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		elif Input.is_action_pressed("ui_up"):
			direction.y -= 1

		direction = direction.normalized()

	velocity = direction * speed * delta * 60 + bump_velocity
	bump_velocity = lerp(bump_velocity, Vector2.ZERO, 0.05)
	move_and_slide()


	if Input.is_action_pressed("ui_accept"):
		animation_director.bow()
	
	if Input.is_action_pressed("speak"):
		speak.start_speak()
	else:
		speak.stop_speak()


func bump(character):
	bump_velocity = 1000*character.global_position.direction_to(global_position)
