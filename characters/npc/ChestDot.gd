extends Spatial

var interaction_text = ["[1] start check compressions"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact_1(relate):
	$"../../../Player/HUD/ChestCompressions".show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
