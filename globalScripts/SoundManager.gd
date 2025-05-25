extends Node

@export var click_sfx: AudioStream = preload("res://assets/sound/click.mp3")
@export var coin_sfx: AudioStream = preload("res://assets/sound/magic_coin.wav")
@export var achievement_sfx: AudioStream = preload("res://assets/sound/coin.mp3")

@export var menu_music: AudioStream = preload("res://assets/music/MENU.mp3")
@export var johanneberg_music: AudioStream = preload("res://assets/music/JOHANNEBERG.mp3")
@export var lindholmen_music: AudioStream = preload("res://assets/music/LINDHOLMEN.mp3")
@export var custom_music: AudioStream = preload("res://assets/music/CUSTOM.mp3")

var debug_enabled := true  # Toggle this to enable/disable debugging

var current_track: AudioStream = null
var music_player: AudioStreamPlayer

var final_volume := -40
var dialogue_volume := final_volume * 1.25
var fade_duration := 2.0

func _ready():
	set_process_input(true)

	music_player = AudioStreamPlayer.new()
	music_player.name = "MusicPlayer"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	music_player.autoplay = false
	music_player.stream = null
	music_player.volume_db = final_volume
	add_child(music_player)

	if debug_enabled:
		print("[SoundManager] Playing menu music on start with volume_db =", music_player.volume_db)
	_play_music(menu_music)

# SOUND EFFECTS (unchanged)
func play_click():
	if debug_enabled: print("[SoundManager] play_click() called")
	_play_one_shot(click_sfx)

func play_coin():
	if debug_enabled: print("[SoundManager] play_coin() called")
	_play_one_shot(coin_sfx)

func play_achievement():
	if debug_enabled: print("[SoundManager] play_achievement() called")
	_play_one_shot(achievement_sfx)

func _play_one_shot(stream: AudioStream) -> void:
	if stream == null:
		if debug_enabled: print("[SoundManager] Warning: Tried to play a null AudioStream")
		return

	if debug_enabled: print("[SoundManager] Playing one-shot sound:", stream.resource_path)

	var temp = AudioStreamPlayer.new()
	temp.stream = stream
	temp.volume_db = final_volume
	add_child(temp)
	temp.play()

	var duration = stream.get_length()
	if debug_enabled: print("[SoundManager] Sound duration:", duration)

	var cleanup_timer = Timer.new()
	cleanup_timer.one_shot = true
	cleanup_timer.wait_time = duration
	add_child(cleanup_timer)

	cleanup_timer.connect("timeout", Callable(temp, "queue_free"))
	cleanup_timer.start()

# GLOBAL CLICK INPUT (unchanged)
func _input(event):
	if event is InputEventMouseButton and event.pressed and GameState.current_state == GameState.MouseState.UI:
		if debug_enabled: print("[SoundManager] Mouse click detected in UI state")
		play_click()

# MUSIC CONTROL
func play_menu_music():
	if debug_enabled: print("[SoundManager] Switching to menu music")
	_play_music(menu_music)

func play_pause_music():
	current_track = music_player.stream
	if debug_enabled:
		print("[SoundManager] Pausing music. Current track:", current_track)
		print("[SoundManager] Current volume_db before pause:", music_player.volume_db)
	play_menu_music()

func exit_pause_music():
	if debug_enabled:
		print("[SoundManager] Exiting pause. Resuming track:", current_track)
		print("[SoundManager] Volume before resuming:", music_player.volume_db)
	_play_music(current_track)

func play_johanneberg_music():
	if debug_enabled: print("[SoundManager] Switching to Johanneberg music")
	_play_music(johanneberg_music, true)

func play_lindholmen_music():
	if debug_enabled: print("[SoundManager] Switching to Lindholmen music")
	_play_music(lindholmen_music, true)

func play_custom_music():
	if debug_enabled: print("[SoundManager] Switching to custom music")
	_play_music(custom_music, true)

func stop_music():
	if music_player.playing:
		if debug_enabled: print("[SoundManager] Stopping current music")
		music_player.stop()

var fade_tween: Tween = null

func _play_music(track: AudioStream, fade_in := false):
	if track == null:
		if debug_enabled: print("[SoundManager] Warning: _play_music called with null track")
		return

	if music_player.stream == track:
		if debug_enabled: print("[SoundManager] Requested music already playing:", track.resource_path)
		return

	if debug_enabled:
		print("[SoundManager] Starting new track:", track.resource_path, "Fade in:", fade_in)
		print("[SoundManager] Current volume_db before setting stream:", music_player.volume_db)

	# Kill any existing fade tween
	if fade_tween and fade_tween.is_valid():
		if debug_enabled: print("[SoundManager] Killing existing fade tween")
		fade_tween.kill()
		fade_tween = null

	music_player.stream = track

	if fade_in:
		music_player.volume_db = -80
		music_player.play()
		if debug_enabled: print("[SoundManager] Set volume_db to -80 for fade-in and started playing")

		fade_tween = create_tween()
		fade_tween.tween_property(music_player, "volume_db", final_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		if debug_enabled:
			print("[SoundManager] Tween started for fade-in to volume_db =", final_volume)
			fade_tween.connect("finished", Callable(self, "_on_fade_in_finished"))
	else:
		music_player.volume_db = final_volume
		music_player.play()
		if debug_enabled: print("[SoundManager] Set volume_db to", final_volume, "and started playing")

func _on_fade_in_finished():
	if debug_enabled:
		print("[SoundManager] Fade-in tween finished. Current volume_db =", music_player.volume_db)

func set_muic_volume(volume):
	if debug_enabled: print("[SoundManager] set_muic_volume called with:", volume)
	final_volume = volume
	music_player.volume_db = final_volume
	if debug_enabled: print("[SoundManager] Music player volume_db set to:", music_player.volume_db)

func set_music_volume_in_dialogue(dialogue: bool):
	if debug_enabled: print("[SoundManager] Adjusting music volume for dialogue. Dialogue active:", dialogue)
	var tween = create_tween()
	if dialogue:
		if debug_enabled: print("[SoundManager] Tweening volume_db to dialogue_volume:", dialogue_volume)
		tween.tween_property(music_player, "volume_db", dialogue_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		if debug_enabled: print("[SoundManager] Tweening volume_db to final_volume:", final_volume)
		tween.tween_property(music_player, "volume_db", final_volume, fade_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
