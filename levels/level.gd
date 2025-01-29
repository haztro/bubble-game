extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for child in get_children():
		child.call_deferred("reparent", get_parent(), true)
		get_tree().get_first_node_in_group("world").start_battle.connect(child.start_battle)
