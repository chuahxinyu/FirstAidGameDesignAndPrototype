extends Control
var prev_time = 0
var count_clicks = 0
var bpm = 0
var bpm_total = 0
var bpm_final = 0
const TIMEOUT = 2200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	if !prev_time:
		prev_time = OS.get_ticks_msec()
	elif (OS.get_ticks_msec()-prev_time) > TIMEOUT:
		reset()
	else:
		var curr_time = OS.get_ticks_msec()
		var time_diff = curr_time - prev_time
		prev_time = curr_time
		bpm = 60.0 / time_diff
		bpm_total = bpm_total + bpm
		count_clicks += 1
		bpm_final = (bpm_total / count_clicks) * 1000
	$MarginContainer2/Body.set_bbcode("BPM: " + String(round(bpm_final)) + "\nCount: " + String(count_clicks))
	
	
func reset():
	var prev_time = 0
	var count_clicks = 0
	var bpm = 0
	var bpm_total = 0
	var bpm_final = 0
