extends KinematicBody

onready var cameras = $Cameras.get_children()

onready var pivot = $Spatial

export var turn_speed = 0.04 # radians/pixel
export var thrust_speed = 300
export var rotate_speed = 0.004

var velocity = Vector3()
var current_camera = 0
var turn_velocity = Vector3.ZERO

func _ready():
	cameras[0].current = true

func turn():
	var turn_vec = Vector3.ZERO
	if Input.is_action_pressed("look_up"):
		turn_vec.x = 1
	if Input.is_action_pressed("look_down"):
		turn_vec.x = -1
	if Input.is_action_pressed("look_left"):
		turn_vec.y = 1
	if Input.is_action_pressed("look_right"):
		turn_vec.y = -1
	if Input.is_action_pressed("rotate_left"):
		turn_vec.z = 1
	if Input.is_action_pressed("rotate_right"):
		turn_vec.z = -1
	turn_velocity = lerp(turn_velocity, turn_vec*turn_speed, 0.02)
	rotate(transform.basis.x, turn_velocity.x)
	rotate(transform.basis.y, turn_velocity.y)
	rotate(transform.basis.z, turn_velocity.z/3)
	

func fly():
	var forward = -transform.basis.z
	var backward = transform.basis.z
	var fly_vec = -int(Input.is_action_pressed("thrust"))+int(Input.is_action_pressed("brake"))
	velocity = lerp(velocity, backward*thrust_speed*fly_vec, 0.01)

func _physics_process(delta):
	turn()
	fly()
	swap_camera()
	velocity = move_and_slide(velocity)



func swap_camera():
	var max_cameras = len(cameras)-1 #I subtract one because in the code below 
	#I annticipate adding one, this means that it will catch it from going over
	if Input.is_action_just_released("ui_focus_next"):
		if current_camera >= max_cameras:
			current_camera = 0
		else:
			current_camera += 1
		cameras[current_camera].current = true

