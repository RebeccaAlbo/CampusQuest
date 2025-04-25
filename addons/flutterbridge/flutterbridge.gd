extends Node

# Check if the platform supports web features (for JavaScriptBridge)
var web_mode := OS.has_feature("web")

# Variable to hold the JavaScript callback function
var js_callback

# Store pending requests for dialogs by speaker name
var pending_requests := {}

# Flag to track if Flutter is ready
var flutter_ready := false

# Signal to notify when Flutter is ready
signal flutter_ready_signal
#Signal to notify that a dialogue has been received
signal dialog_received(speaker: String, dialogues: Array)



func _ready():
	# Skip execution in the editor mode
	if Engine.is_editor_hint():
		return
	
	# Set up the JavaScript bridge
	_setup_js_bridge()

# Set up the JavaScript bridge for communication with Flutter
func _setup_js_bridge():
	# Check if web mode is supported (JavaScriptBridge)
	if not web_mode:
		print("[FlutterBridge] JavaScriptBridge not available on this platform.")
		return

	# Create the JavaScript callback that will handle messages from JS
	js_callback = JavaScriptBridge.create_callback(_on_js_message)

	# JavaScript code to set up the bridge and listen for messages
	var js_code := """
		window.godotBridge = {
			callback: null,
			setCallback: function(cb) { this.callback = cb; },
			sendMessage: function(msg) {
				if (this.callback) this.callback(msg);
			}
		};

		window.addEventListener('message', function(event) {
			const message = event.data;
			if (!message?.type) return;

			switch (message.type) {
				case 'dialog_receive':
				case 'flutter_ready':
					if (window.godotBridge) {
						const json = JSON.stringify(message);
						window.godotBridge.sendMessage(json);
					}
					break;
			}
		});
	"""
	# Evaluate the JavaScript code to set up the bridge
	JavaScriptBridge.eval(js_code, true)

	# Get the interface for the Godot-JavaScript bridge and set the callback
	var godot_bridge = JavaScriptBridge.get_interface("godotBridge")
	godot_bridge.setCallback(js_callback)

	# Notify Flutter that Godot is ready
	JavaScriptBridge.eval("window.parent.postMessage({ type: 'godot_ready' }, '*');", true)
	print("[FlutterBridge] Godot bridge is ready!")

# Request a dialog from Flutter by speaker name
func request_dialog(speaker: String) -> Array:
	if not web_mode:
		print("[FlutterBridge] Web platform not available.")
		return []

	if not flutter_ready:
		print("[FlutterBridge] Waiting for Flutter to become ready...")
		await flutter_ready_signal
		print("[FlutterBridge] Flutter is now ready!")

	print("[FlutterBridge] Requesting dialog for:", speaker)

	# Send the request
	var js := "window.parent.postMessage({ type: 'dialog_request', speaker: '" + speaker + "' }, '*');"
	JavaScriptBridge.eval(js, true)

	# Await dialog response
	print("[FlutterBridge] Waiting for dialog response for speaker:", speaker)

	var args = await dialog_received
	print("speaker: ", args[0])
	print("data: ", args[1])
	
	var result = args[1] if args != null and args.size() > 1 else []

	print("[FlutterBridge] Dialog response received for speaker:", speaker)
	
	print("[FlutterBridge] result:", result)
	pending_requests.erase(speaker)
	return result


# This function is called when a message is received from JavaScript
func _on_js_message(args: Array):
	# If no arguments were passed from JS, return early
	if args.size() == 0:
		print("[FlutterBridge] No arguments passed from JS")
		return

	# Parse the JSON string received from JS
	var json_str: String = args[0]  # Explicitly declare the type as String
	var parsed = JSON.parse_string(json_str)

	# If the parsed data is a dictionary (valid JSON object), process it
	if parsed is Dictionary:
		match parsed.get("type", ""):
			# Handle Flutter ready signal
			"flutter_ready":
				print("[FlutterBridge] Flutter is ready!")
				flutter_ready = true  # Set the flag that Flutter is ready
				emit_signal("flutter_ready_signal")  # Emit signal to notify waiting functions

			# Handle dialog data reception
			"dialog_receive":
				var dialog_data: Array = parsed.get("data", [])
				var speaker: String = parsed.get("speaker", "Unknown")

				if dialog_data is Array:
					print("[FlutterBridge] Dialog received for speaker:", speaker, "Data:", dialog_data)
					emit_signal("dialog_received", speaker, dialog_data)
				else:
					print("[FlutterBridge] dialog_receive data is not an array")
	else:
		print("[FlutterBridge] Failed to parse JSON")
