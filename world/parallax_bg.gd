extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print($Mountain3/Mountain3_1.offset)



func print_offset():
	print($Sky.scroll_offset)
	print($Mountain3.scroll_offset)
	print($Mountain2.scroll_offset)
	print($Mountain4.scroll_offset)
	print($foreground.scroll_offset)
	print($foreground2.scroll_offset)
	
func set_offset(val1, val2, val3, val4, val5, val6):
	$Sky.scroll_offset = val1
	$Mountain3.scroll_offset = val2
	$Mountain2.scroll_offset = val3
	$Mountain4.scroll_offset = val4
	$foreground.scroll_offset = val5
	$foreground2.scroll_offset = val6
	
