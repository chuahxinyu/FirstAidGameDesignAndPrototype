extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in $MenuButtons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
