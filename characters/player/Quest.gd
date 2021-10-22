extends MarginContainer

export(String) var message
var is_complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_complete:
		$Quest.set_bbcode("[color=green][x] " + message+"[/color]")
	else:
		$Quest.set_bbcode("[ ] " + message)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_complete:
		$Quest.set_bbcode("[color=green][x] " + message+"[/color]")
	else:
		$Quest.set_bbcode("[ ] " + message)
	if message == "":
		self.hide()
