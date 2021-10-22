extends KinematicBody

# Movement variables
const GRAVITY = -24.8
var vel = Vector3()
var dir = Vector3()
const MAX_SPEED = 10
const ACCEL = 4.5
const DEACCEL = 16
const MAX_SLOPE_ANGLE = 40

var MOUSE_SENSITIVITY = 0.05

# Slow
var is_slow = false
const SLOW_SPEED = 5

# Interaction variables
var interaction_ray
var carried_object = null

# Camera variables
var camera
var rotation_helper

# Toggle extra information
var show_extra = false
var extra_text

# Toggle controls information
var show_controls = false

# Toggle crouching
var is_crouching = false

# Quests
#var quests = {
##	"Name": [subquest1_complete?, subquest2_complete?]
#	"Danger": false,		# stop bus
#	"Response": false,		# 
#	"Airway": false,		# head tilt chin lift
#	"Breathing": false,		# determine breathing
#	"CallForHelp": false,	# 
#	"Circulation": false	# CPR
#}

# Extra info
var extra_info = {
	0: "Welcome aboard to the first (and only) level of FIRST AID: the game prototype (and design). This prototype will primarily focus on gameplay, mechanics and be a proof of concept for what the actual game could be - so literally everything you see is a 'placeholder object'. Green cubes tell you more about the game design while green spheres give visual/audio cues that could not be added in the prototype due to lack of technical expertise. ",
	1: "[i][Voice] You: Great, looks like I'm going to be late again. Can this train go any faster...[/i]",
	2: "[i][SFX] Thud.\n[Voice] You: Did you hear that? Sounds like someone fell or something, somewhere at the back.[/i]",
	3: "[i][Voice] You: Woah, it's kind of dangerous to move around the tram while it's still moving...[/i]",
	4: "Unfortunately, the game prototype basically ends here, after viewing the patient, there are actions that you can take in order to help them out (you can hover over the green dots) and learn how to do a primary survey of a patient (DR.ABC: Danger, Reponsonse, Airway, Breathing, Call for help, Circulation) with mechanics similar to the game pitch (chest compressions and breaths) but with NPCs and more options."
}

# Cues
var cues = {
	
}

const GROUP = 0
const TASKS = 1
const MESSAGE = 0
const IS_COMPLETE = 1

# Checklist
var checklist = {
	"Controls":
		[["Use your mouse to look around and hover the crosshair over the green cube.", false],
		["Press [code][T][/code] to show the controls menu.", false],
		["Check what time it is. Hover the crosshair over the small green circle.", false]],
	"Danger":
		[["Ensure that the situation is safe for [b]you[/b], bystanders and the patient.", false],
		["", false],
		["", false]],
	"Response":
		[["Determine the patient's response level.", false],
		["", false],
		["", false]],
	"Airway":
		[["Open the patient's airway (head tilt/chin lift).", false],
		["", false],
		["", false]],
	"Breathing":
		[["Determine if the patient is breathing.", false],
		["", false],
		["", false]],
	"Call for help":
		[["Call emergency services.", false],
		["", false],
		["", false]],
	"Circulation":
		[["Ensure that blood is still circulating through the patient's body.", false],
		["", false],
		["", false]]
}

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	interaction_ray = $Rotation_Helper/InteractionRay
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta):
	# Checklist
	for key in checklist.keys():
		$HUD/Checklist/VBoxContainer/Group/Text.set_bbcode(key)
		var break_flag = false

		if checklist[key][0][IS_COMPLETE] == false:
			$HUD/Checklist/VBoxContainer/Quest1.message = checklist[key][0][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest1.is_complete = false
			break_flag = true
		elif checklist[key][0][IS_COMPLETE] == true:
			$HUD/Checklist/VBoxContainer/Quest1.message = checklist[key][0][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest1.is_complete = true

		if checklist[key][1][IS_COMPLETE] == false:
			$HUD/Checklist/VBoxContainer/Quest2.message = checklist[key][1][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest2.is_complete = false
			break_flag = true
		elif checklist[key][1][IS_COMPLETE] == true:
			$HUD/Checklist/VBoxContainer/Quest2.message = checklist[key][1][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest2.is_complete = true

		if checklist[key][2][IS_COMPLETE] == false:
			$HUD/Checklist/VBoxContainer/Quest3.message = checklist[key][2][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest3.is_complete = false
			break_flag = true
		elif checklist[key][2][IS_COMPLETE] == true:
			$HUD/Checklist/VBoxContainer/Quest3.message = checklist[key][2][MESSAGE]
			$HUD/Checklist/VBoxContainer/Quest3.is_complete = true
		if break_flag:
			break

	if $"HUD/FPSAndTime/MarginContainer/fps and time".minutes == 10:
		pass
	if $"HUD/FPSAndTime/MarginContainer/fps and time".seconds == 15:
		pass
	if interaction_ray.is_colliding():
		var object = interaction_ray.get_collider()
		if object.has_method("pick_up"):
			$HUD/interaction_text.set_text("[F] Pick up " + object.get_name())
		elif object.has_method("interact_1"):
			var text = ""
			for i in object.interaction_text:
				text += i
				text += "\n"
			$HUD/interaction_text.set_text(text)
		elif object.has_method("show_information") and object.show == true:
			$HUD/ExtraText.show()
			$HUD/ExtraText/MarginContainer/ExtraTextLabel.set_bbcode(extra_info[object.id])
			if object.id == 0:
				checklist["Controls"][0][IS_COMPLETE] = true
		else:
			$HUD/ExtraText.hide()
			$HUD/interaction_text.set_text("")
	else:
		$HUD/ExtraText.hide()
		$HUD/interaction_text.set_text("")
	
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
	if Input.is_action_just_pressed("interact_1"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("show_information") and !object.show:
				$HUD/ExtraText.show()
				$HUD/ExtraText/MarginContainer/ExtraTextLabel.set_bbcode(extra_info[object.id])
			if object.has_method("interact_1"):
				object.interact_1(self)
	if Input.is_action_just_pressed("interact_2"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("interact_2"):
				object.interact_2(self)
			if object.has_method("show_information") and !object.show:
				$HUD/ExtraText/MarginContainer/ExtraTextLabel.set_bbcode(extra_info[object.id])
	if Input.is_action_just_pressed("interact_3"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("interact_3"):
				object.interact_3(self)
			if object.has_method("show_information") and !object.show:
				$HUD/ExtraText/MarginContainer/ExtraTextLabel.set_bbcode(extra_info[object.id])
	if Input.is_action_just_pressed("interact_4"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			if object.has_method("interact_4"):
				object.interact_4(self)
			if object.has_method("show_information") and !object.show:
				$HUD/ExtraText/MarginContainer/ExtraTextLabel.set_bbcode(extra_info[object.id])
	
	# Show/Hide Extra Text -----------------------------------------------------
	if Input.is_action_just_pressed("show_extra_text"):
		if interaction_ray.is_colliding():
			var object = interaction_ray.get_collider()
			
		show_extra = !show_extra
		
	# Show/Hide Controls - -----------------------------------------------------
	if Input.is_action_just_pressed("show_controls"):
		checklist["Controls"][1][IS_COMPLETE] = true
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
	if is_slow:
		target *= SLOW_SPEED
	else:
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
	if anim_name == "crouch":
		is_crouching = !is_crouching
	if anim_name == "shake" and is_slow:
		$AnimationPlayer.play("shake")

func end_level(end_message_index):
	get_tree().change_scene("res://levels/LevelEnd.tscn")
