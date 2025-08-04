extends Node2D
@onready var label: Label = $Price/Label
var price: float = 9999.99
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func set_price(new_price: float):
	gpu_particles_2d.emitting = true
	price = new_price
	label.text = str(new_price)
