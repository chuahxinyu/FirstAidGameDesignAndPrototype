extends Spatial
# Camera variables
var camera
var rotation_helper
const MOUSE_SENSITIVITY = 0.005

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$Transition.fade_out()

func _input(event):
	if event is InputEventMouseMotion:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		rotation_helper.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY))
#		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, -1.2, 1.2)

func _on_Transition_faded_out():
	get_tree().change_scene("res://levels/LevelMenu.tscn")
