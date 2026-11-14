extends CharacterBody2D
class_name Player

@export_category("Movement")
@export var GRAVITY : float
@export var MAX_FALL_SPEED : float
@export var SPEED : float
#@export var JUMP_VELOCITY : float = 1000.0
@export var JUMP_DIST : float
@export var ACCELERATION : float
@export var FRICTION : float

##THIS CATEGORY CAN BE MOVED INTO A GLOBAL SCRIPT FOR EASIER SAVING
@export_category("Power-ups")
@export var hasDoubJump : bool
@export var hasDash : bool
@export var hasWallJump : bool

@export_category("Dash Stats")
@export var	dashDist : float
@export var dashDur : float

@onready var FSM : StateMachine = $FSM
@onready var StateLabel : Label = $DebugState

##Player wide global variables
var canCoyote : bool = true #COYOTE JUMPING FLAG IS BUGGY! FIND COYOTE JUMP LOGIC IN FALL
var isFalling : bool = false
var jump_ctr : int = 0
var justDashed : bool = false
var direction : float
var last_dir : float = 1.0 #WARNING! THIS IS INITIALIZED TO 1.0 TO FORCE THE PLAYER TO FACE RIGHT

##Testing
var max_velx : float = 0.0

func _physics_process(delta: float) -> void:
	
	#print("PLAYER SCRIPT DEBUG: ", canCoyote)
	#print("PLAYER SCRIPT DEBUG: ", last_dir)
	#print("PLAYER SCRIPT DEBUG: ", velocity.y)
	
	if last_dir == 1:
		if max_velx < velocity.x:
			max_velx = velocity.x
	else:
		if -max_velx > velocity.x:
			max_velx = velocity.x
		
	
	StateLabel.text = FSM.cur_state.name
	friction()
	
	clamp(velocity.x, -SPEED, SPEED)
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if isFalling:
			velocity.y += GRAVITY*1.5 * delta
	
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

func friction() -> void:
	direction = Input.get_axis("mov_left", "mov_right")
	if !direction:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
	else:
		last_dir = direction
