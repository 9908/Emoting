extends Node2D
@onready var label: Label = $Price/Label
var price: float = 9999.99
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@onready var price_asset: Node2D = $Price
var lock_show_price: bool = false

func _ready():
	hide_price()
	

func set_price(new_price: float):
	gpu_particles_2d.emitting = true
	price = new_price
	label.text = str(new_price)


func show_price(lock: bool = false):
	price_asset.show()
	if lock:
		lock_show_price = true


func hide_price():
	if lock_show_price:
		return
	price_asset.hide()
