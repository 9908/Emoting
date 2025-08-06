extends Chara

@export var can_be_controlled: bool = true
@onready var victory: Node2D = $Victory
@onready var broom_victory: Sprite2D = $Victory/BroomVictory


func _ready() -> void:
	Globals.player = self
	victory.hide()
	# FLAG-SFX - REGi-SFX - stars
	#FmodServer.play_one_shot("event:/wind")

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if not animation_director.playing_custom_animation and bump_velocity.length() < 100 and can_be_controlled:
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


func get_broom():
	victory.show()
	can_be_controlled = false
	lookat.look_up()
	await get_tree().create_timer(2.0).timeout
	Globals.fade.fade(1.0, 3.0, Color.WHITE)
	await get_tree().create_timer(3.0).timeout
	Globals.fade.fade(0.0, 1.0, Color.WHITE)
	Globals.main.game_win.show()
	
	
