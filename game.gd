extends Node


enum UNIT_TYPE {
	SMALL,
	MEDIUM,
	LARGE
}

enum GAME_STATE {
	MENU,
	BASE,
	FIGHT,
}

const ACCELERATION: float = 0.5
const FRICTION: float = 0.2
const ATTACK_DISTANCE: float = 15
const ATTACK_DISTANCE_X: float = 20
const ATTACK_DISTANCE_Y: float = 30
const ATTACK_RADIUS_SQR: float = 20

const CELEBRATION_TIME: float = 0.1
const CAMERA_BUILDING_DELAY: float = 0.3
const BUILDING_FLY_TIME: float = 8.0
const CAM_TO_BASE_TIME: float = 2.0


const MAX_SPEED: int = 10
const MAX_WORTH: int = 10
const MAX_LEVELS: int = 8

var UPGRADE_SPEED_COST: float = 20
var UPGRADE_WORTH_COST: float = 20

var UNIT_COSTS = {
	Game.UNIT_TYPE.SMALL: 10,
	Game.UNIT_TYPE.MEDIUM: 30,
	Game.UNIT_TYPE.LARGE: 100,
}

var BARRACKS_UPGRADE_COSTS = {
	0: 50,
	1: 100,
}

var bubble_bux = 100000
var game_state: GAME_STATE = GAME_STATE.MENU
var level: int = 0
var parallax_positions = []
var camera_pos: Vector2 = Vector2.ZERO


var unit_data = []


func inc_speed_cost(tier):
	UPGRADE_SPEED_COST *= 3
	
func inc_worth_cost(tier):
	UPGRADE_WORTH_COST *= 3
	
	
func buy_bubble(unit_type) -> bool:
	if bubble_bux >= UNIT_COSTS[unit_type]:
		bubble_bux -= UNIT_COSTS[unit_type]
		return true
	return false
	
	
func buy_speed_upgrade(current_tier: int) -> bool:
	if bubble_bux >= UPGRADE_SPEED_COST:
		bubble_bux -= UPGRADE_SPEED_COST
		inc_speed_cost(current_tier)
		return true
	return false
	
	
func buy_worth_upgrade(current_tier: int) -> bool:
	if bubble_bux >= UPGRADE_WORTH_COST:
		bubble_bux -= UPGRADE_WORTH_COST
		inc_worth_cost(current_tier)
		return true
	return false
	
	
func buy_barracks_upgrade(current_tier: int) -> bool:
	if bubble_bux >= BARRACKS_UPGRADE_COSTS[current_tier]:
		bubble_bux -= BARRACKS_UPGRADE_COSTS[current_tier]
		return true
	return false


func reset_game():
	bubble_bux	= 50
	UPGRADE_SPEED_COST = 20
	UPGRADE_WORTH_COST = 20
	level = 0
	game_state = GAME_STATE.MENU
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
