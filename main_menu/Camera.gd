extends Spatial
# Camera variables
var camera
var rotation_helper

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	
	for button in $MenuButtons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	
func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
	
var MOUSE_SENSITIVITY = 0.005

func _input(event):
	if event is InputEventMouseMotion:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		rotation_helper.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY))
#		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, -1.2, 1.2)

