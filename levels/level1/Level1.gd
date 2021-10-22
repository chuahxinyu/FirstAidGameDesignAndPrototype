extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SlowArea1_body_entered(body):
	if body == $Player and !$Player.checklist["Danger"][0][1]:
		$Player.is_slow = true
		$Player/AnimationPlayer.play("shake")

func _on_SlowArea2_body_entered(body):
	if body == $Player and !$Player.checklist["Danger"][0][1]:
		$Player.end_level(0)
