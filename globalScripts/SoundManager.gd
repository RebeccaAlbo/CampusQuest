extends Node

@export var click_sfx: AudioStream = preload("res://sounds/click.mp3")
@export var achievement_sfx: AudioStream = preload("res://sounds/coin.mp3")

func play_click():
	_play_one_shot(click_sfx)


func play_coin():
	_play_one_shot(achievement_sfx)

func _play_one_shot(stream: AudioStream) -> void:
	if stream == null:
		return

	var temp = AudioStreamPlayer.new()
	temp.stream = stream
	add_child(temp)
	temp.play()

	# Use a timer to free the temp player after the stream finishes
	var duration = stream.get_length()
	var cleanup_timer = Timer.new()
	cleanup_timer.one_shot = true
	cleanup_timer.wait_time = duration
	add_child(cleanup_timer)

	cleanup_timer.connect("timeout", Callable(temp, "queue_free"))
	cleanup_timer.start()
