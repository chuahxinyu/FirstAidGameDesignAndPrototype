extends Label

var time_start = 0
var time_now = 0
export(int) var minutes
export(int) var seconds

func _ready():
	time_start = OS.get_unix_time()
	set_process(true)
	
func _process(delta):
	time_now = OS.get_unix_time()
	var elapsed = time_now - time_start
	minutes = elapsed / 60
	seconds = elapsed % 60
	var str_elapsed = "%02d : %02d" % [minutes, seconds]
	set_text("Time Elapsed: " + str_elapsed)
