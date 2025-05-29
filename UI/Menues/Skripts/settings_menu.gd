extends Control
#this script is a bit messy beacuse it need to work for both the main and pause menu
@onready var pause_menu: Control
@onready var tts_label = $Panel/VBoxContainer/TTS
@onready var volume_slider = $Panel/VBoxContainer/HSlider

func _ready() -> void:
	volume_slider.value = SoundManager.final_volume
	
	if FlutterBridge.tts_active:
		tts_label.text = "Text-To-Speech ON"
		tts_label.button_pressed = false
		print("[tts_menu] TTS enabled. tts_label text set to 'Text-To-Speech ON', process_mode = true")
	else:
		tts_label.text = "Text-To-Speech OFF"
		tts_label.button_pressed = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and visible:
		get_viewport().set_input_as_handled()  # Fully consumes the event
		print("settings esc")
		_on_back_pressed()

func _on_back_pressed() -> void:
	if pause_menu:
		if visible:
			visible = false
			pause_menu.paused = false
			print("settings pause exit")
	else: 
		print("settings main exit")
		get_tree().change_scene_to_file(SceneManager.prev_scene_path)

func _on_tts_pressed() -> void:
	FlutterBridge.tts_active = not FlutterBridge.tts_active
	
	if FlutterBridge.tts_active:
		tts_label.text = "Text-To-Speech ON"
		tts_label.button_pressed = false
		print("[tts_menu] TTS enabled. tts_label text set to 'Text-To-Speech ON', process_mode = true")
	else:
		tts_label.text = "Text-To-Speech OFF"
		tts_label.button_pressed = true


func _on_h_slider_value_changed(value: float) -> void:
	await get_tree().create_timer(0.1).timeout
	SoundManager.set_muic_volume(value)
