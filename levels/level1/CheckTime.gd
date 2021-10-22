extends StaticBody

export(bool) var show
export(int) var id
var interaction_text = ["[1] check time"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact_1(relate):
	$"../../Player/HUD/FPSAndTime".show()
	$"../../Player".checklist["Controls"][2][1] = true

func show_information():
	pass
