class_name Barracks
extends "res://world/building.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	anim_player.seek(0.4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func upgrade():
	super.upgrade()
