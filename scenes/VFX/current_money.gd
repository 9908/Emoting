extends Node2D

@onready var flash_no_money: AnimationPlayer = $FlashNoMoney
@onready var broom: Node2D = $"../Broom"
@onready var area_2d: Area2D = $Area2D


func broom_price_lowered():
	if area_2d.overlaps_body(Globals.player):
		_on_area_2d_body_entered(Globals.player)
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Globals.player:
		broom.show_price()
		if broom.price == 0.0:
			Globals.player.get_broom()
			broom.queue_free()
		else:
			flash_no_money.play("new_animation")
		

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Globals.player:
		flash_no_money.play("RESET")
		broom.hide_price()
