extends RigidBody3D

var mouse_sensitivity := 0.001
# Horizontal
var twist_input := 0.0
# Vertical
var pitch_input := 0.0

# Variables are evaluated on the _ready function command
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	# Aligning the Camera direction such that the object moves in the direction 
	# the camera is facing
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
#	When ESCAPE is pressed, enable mouse visibility
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		# Godot mainly works in Radians, Can convert to degrees using deg_to_rad 
		# function
		-0.5, # Equivalent to -30 degrees
		0.5 # Equivalent to 30 degrees
	)
	
	# Set the input to stop the camera from endlessly moving
	twist_input = 0.0
	pitch_input = 0.0
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
