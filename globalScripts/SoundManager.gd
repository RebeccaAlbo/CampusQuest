extends Node

@export var click_sfx: AudioStream = preload("res://assets/sound/click.mp3")
@export var coin_sfx: AudioStream = preload("res://assets/sound/magic_coin.wav")
@export var achievement_sfx: AudioStream = preload("res://assets/sound/coin.mp3")

@export var menu_music: AudioStream = preload("res://assets/music/MENU.mp3")
@export var johanneberg_music: AudioStream = preload("res://assets/music/JOHANNEBERG.mp3")
@export var lindholmen_music: AudioStream = preload("res://assets/music/LINDHOLMEN.mp3")
@export var custom_music: AudioStream = preload("res://assets/music/CUSTOM.mp3")

var current_track: AudioStream = null

var music_player: AudioStreamPlayer

var final_volume := -40
var dialogue_volume := -50
var fade_duration := 2.0

func _ready():
	set_process_input(true)
	
	# Create a persistent music player node
	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.autoplay = false
	music_player.stream = null
	music_player.volume_db = final_volume
	add_child(music_player)
	_play_music(menu_music)

# SOUND EFFECTS
func play_click():
	_play_one_shot(click_sfx)

func play_coin():
	_play_one_shot(coin_sfx)

func play_achievement():
	_play_one_shot(achievement_sfx)

func _play_one_shot(stream: AudioStream) -> void:
	if stream == null:
		return

	var temp = AudioStreamPlayer.new()
	temp.stream = stream
	add_child(temp)
	temp.play()

	var duration = stream.get_length()
	var cleanup_timer = Timer.new()
	cleanup_timer.one_shot = true
	cleanup_timer.wait_time = duration
	add_child(cleanup_timer)

	cleanup_timer.connect("timeout", Callable(temp, "queue_free"))
	cleanup_timer.start()

# GLOBAL CLICK INPUT
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		play_click()

# MUSIC CONTROL
func play_menu_music():
	
	_play_music(menu_music)
	
func play_pause_music():
	current_track = music_player.stream  # Track currently playing music
	play_menu_music()
	
func exit_pause_music():
	_play_music(current_track)
	
func play_johanneberg_music():
	_play_music(johanneberg_music, true)

func play_lindholmen_music():
	_play_music(lindholmen_music, true)
	
func play_custom_music():
	_play_music(custom_music, true)
	
	
func stop_music():
	if music_player.playing:
		music_player.stop()

func _play_music(track: AudioStream, fade_in := false):
	if music_player.stream == track:
		return  # Already playing this track
	music_player.stream = track
	if fade_in:
		music_player.volume_db = -80  # Start silent
		music_player.play()
		
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", final_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		music_player.volume_db = final_volume
		music_player.play()
		
func set_music_volume_in_dialogue(dialogue: bool):
	print("set_music_volume_in_dialogue is: ", dialogue)
	var tween = create_tween()
	if (dialogue):
		tween.tween_property(music_player, "volume_db", dialogue_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else: 
		tween.tween_property(music_player, "volume_db", final_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
