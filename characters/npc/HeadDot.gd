extends Spatial

var second_time = false
var interaction_text = ["[1] head tilt/chin lift", "[2] pinch earlobes", "[3] assess head wound", "[4] determine response level"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func interact_1(relate):
	if second_time:		# check for breathing
		pass
	else:
		interaction_text = ["[1] check for breathing", "[2] give rescue breaths"]

func interact_2(relate):
	if second_time:
		pass
	else:
		pass

func interact_3(relate):
	pass

func interact_4(relate):
	pass
