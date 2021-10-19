extends KinematicBody

# Movement variables
const GRAVITY = -24.8
var vel = Vector3()
var dir = Vector3()
const MAX_SPEED = 10
const SPRINT_SPEED = 20
const SLOW_SPEED = 5
const ACCEL = 4.5
const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var MOUSE_SENSITIVITY = 0.05

# Interactio variables
var interaction_ray
var carried_object = null

# Camera variables
var camera
var rotation_helper

# Toggle extra information
var show_extra = true
var extra_text

# Toggle controls information
var show_controls = false

# Toggle crouching
var is_crouching = false

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	interaction_ray = $Rotation_Helper/InteractionRay
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	if interaction_ray.is_colliding():
		var object = interaction_ray.get_collider()
		if object.has_method("pick_up"):
			$HUD/interaction_text.set_text("[F] Pick up " + object.get_name())
		elif object.has_method("interact"):
			$HUD/interaction_text.set_text("[E] Interact with " + object.get_name())
		else:
			$HUD/interaction_text.set_text("")
	else:
			$HUD/interaction_text.set_text("")
	
	if show_extra:
		$HUD/ExtraText.show()
	else:
		$HUD/ExtraText.hide()
		
	if show_controls:
		$HUD/Controls.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		$HUD/Controls.hide()

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

## Handles all player input
func process_input(_delta):
	# Reset direction
	dir = Vector3()
	
	# Get camera's global transform to use its directional vectors
	var cam_xform = camera.get_global_transform()
	
	# Walking ------------------------------------------------------------------
	var input_movement_vector = Vector2()
	
	if Input.is_action_pressed("movement_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("movement_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("movement_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("movement_right"):
		input_movement_vector.x += 1
	input_movement_vector = input_movement_vector.normalized()
	
	# Bases vectors are already normalized
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# Crouching ----------------------------------------------------------------
	if Input.is_action_pressed("crouch"):
		if is_crouching:
			$AnimationPlayer.play_backwards("crouch")
		else:
			$AnimationPlayer.play("crouch")

	# Capturing/Freeing the cursor ---------------------------------------------
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE \
		and (Input.is_action_just_pressed("ui_cancel")):
#			or Input.is_action_just_pressed("click")):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED \
		and Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Pick Up items ------------------------------------------------------------
	if carried_object != null and (Input.is_action_just_pressed("pick_up")
									or Input.is_action_just_pressed("click")):
		carried_object.pick_up(self)
	elif Input.is_action_just_pressed("pick_up"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("pick_up"):
				object.pick_up(self)
	
	# Interact with items ------------------------------------------------------
	if Input.is_action_just_pressed("interact"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("interact"):
				object.interact(self)
	
	# Show/Hide Extra Text -----------------------------------------------------
	if Input.is_action_just_pressed("show_extra_text"):
		show_extra = !show_extra
		
	# Show/Hide Controls - -----------------------------------------------------
	if Input.is_action_just_pressed("show_controls"):
		show_controls = !show_controls
		if show_controls == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

## Handles player movement. Sends all the data necessary to the KinematicBody to
## move through the game world.
func process_movement(delta):
	dir.y = 0
	# normalise so speed is costant regardless of moving straight or diagonally
	dir = dir.normalized()

	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0
	
	var target = dir
	target *= MAX_SPEED
	
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
		
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, 
							deg2rad(MAX_SLOPE_ANGLE))

## Handles mouse/camera movement
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() \
											== Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -80, 80)
		rotation_helper.rotation_degrees = camera_rot


func _on_crouch_animation_finished(anim_name):
	is_crouching = !is_crouching
