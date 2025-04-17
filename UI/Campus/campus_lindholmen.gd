extends Node

func _ready():
	# Get the reference to our Flutter plugin
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		print("Flutter plugin is available")
		
		# Connect to signals from Flutter
		flutterPlugin.connect("flutter_to_godot_signal", _on_message_from_flutter)
	else:
		print("Flutter plugin is not available")

# Handler for messages coming from Flutter
func _on_message_from_flutter(message):
	print("Message from Flutter: ", message)
	
	# Process the message here
	# ...
	
	# Optionally send a response back to Flutter
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		flutterPlugin.sendMessageToFlutter("Response from Godot")

# Function to send a message to Flutter at any time
func send_to_flutter(message):
	var flutterPlugin = Engine.get_singleton("FlutterGodotPlugin")
	if flutterPlugin:
		flutterPlugin.sendMessageToFlutter(message)
