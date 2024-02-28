extends Node

var stab = load("res://Abilities/Stab/stab.tscn")

@export var damage = 0
@export var tileRange = 1
var actualRange = 64
var caster
var direction = null

func _ready():
	range_convert()
	print($Hitbox.target_position)

func range_convert():
	actualRange = tileRange * AutoloadMe.tile_size.x
	$Hitbox.target_position = Vector2(0, actualRange)

# Get location of caster, project an array that is range of attack (1 tile cardinal direction ray), mouse pos clamp ray. Highlight tile. 
func queue(s):
	caster = s
	set_process(true)
	

func _process(_delta):
	pass

# Create hitbox, Get unit in the hitbox, send entered signal, lose health with ability damage var.
func execute():
	pass

