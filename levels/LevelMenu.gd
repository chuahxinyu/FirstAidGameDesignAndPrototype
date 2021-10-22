extends Control

var show_extra = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("show_extra_text"):
		show_extra = !show_extra
		if show_extra:
			$ExtraText.show()
		else:
			$ExtraText.hide()


func _on_StartButton_pressed():
	get_tree().change_scene("res://levels/level1/Level1.tscn")
