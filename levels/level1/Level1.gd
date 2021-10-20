extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_SlowArea1_body_entered(body):
	if body == $Player and !$Player.quests["Danger"]:
		$Player.is_slow = true
		$Player/AnimationPlayer.play("shake")
		print("entered slowarea1")

func _on_SlowArea2_body_entered(body):
	if body == $Player and !$Player.quests["Danger"]:
		$Player.end_level(0)
		print("entered slowarea2")

