extends StaticBody

var interaction_text = ["[1] stop the tram"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact_1(relate):
	$"../../Player".checklist["Danger"][0][1] = true
	$"../../Player".is_slow = false
	print("Stopping the tram!")
