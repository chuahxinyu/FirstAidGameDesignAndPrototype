extends MarginContainer

export(String) var alt_text
export(String) var scene_to_load

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var level_name = self.get_name()
	if "LvlName" in level_name:
		$MarginContainer/RichTextLabel.set_bbcode(alt_text)
	else:
		$MarginContainer/RichTextLabel.set_bbcode("[center][b][i]"+level_name+"[/i][/b]")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
