extends Node


const ACCELERATION: float = 0.5
const FRICTION: float = 0.2
const ATTACK_DISTANCE: float = 15
const ATTACK_DISTANCE_X: float = 20
const ATTACK_DISTANCE_Y: float = 30
const ATTACK_RADIUS_SQR: float = 20

var bubbles = {}
var bubble_id: int = 0



func add_bubble(bubble: Bubble):
	bubble.bubble_id = bubble_id
	bubbles[bubble_id] = bubble
	bubble_id += 1
	
	
func remove_bubble(bubble_id: int):
	bubbles.erase(bubble_id)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
