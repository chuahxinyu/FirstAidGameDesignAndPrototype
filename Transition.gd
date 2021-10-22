extends CanvasLayer

signal faded_out
signal faded_in

func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		emit_signal("faded_out")
	if anim_name == "fade_in":
		emit_signal("faded_in")
		
