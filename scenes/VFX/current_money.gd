extends Node2D

@onready var flash_no_money: AnimationPlayer = $FlashNoMoney
@onready var broom: Node2D = $"../Broom"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		if broom.price == 0.0:
			broom.queue_free()
			Globals.player.get_broom()
		else:
			flash_no_money.play("new_animation")
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Globals.player:
		flash_no_money.play("RESET")
