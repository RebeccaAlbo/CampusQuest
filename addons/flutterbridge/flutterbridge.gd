extends Node

# Check if the platform supports web features (for JavaScriptBridge)
var web_mode := OS.has_feature("web")


# Variable to hold the JavaScript callback function
var js_callback

# Flag to track if Flutter is ready
var flutter_ready := false

var speakers = [
	"anglia",
	"architecture",
	"chemistry",
	"computer",
	'economic',
	"electrical",
	"industrial",
	"jupiter",
	"kuggen",
	"life",
	"math",
	"mechanics",
	"micro",
	"npc_2",
	"patricia",
	"physics",
	"saga",
	"science",
	"space",
	"svea",
	"äran"
]

# Signal to notify when Flutter is ready
signal flutter_readied
# Signal to notify when Flutter saved the game
signal game_saved(success: bool)
# Signal to notify when Flutter saved the game
signal game_quited(success: bool)
#Signal to notify that a dialogue has been received
signal dialog_received(speaker: String, dialogues: String)
#Signal to notify that a score has been received
signal score_received(score: int)
#Signal to notify that a game info has been received
signal game_received(game_data: Dictionary)


func _ready():
	print("[Godot _ready]  Available speakers: ", speakers)
	
	# Skip execution in the editor mode
	if Engine.is_editor_hint():
		return
	
	# Set up the JavaScript bridge
	_setup_js_bridge()

# Set up the JavaScript bridge for communication with Flutter
func _setup_js_bridge():
	# Check if web mode is supported (JavaScriptBridge)
	if not web_mode:
		print("[Godot]  JavaScriptBridge not available on this platform.")
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
				case 'dialog_response':
				case 'flutter_ready':
				case 'speakers_request':
				case 'score_response':
				case 'game_response':
				case 'save_response':
				case 'quit_response':
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
	print("[Godot]  Godot bridge is ready!")

# Request a dialog from Flutter by speaker name
#returns a list of dialogues
#use like this:
#var dialog_data := await FlutterBridge.request_dialog("Fysik")

func request_dialog(speaker: String) -> String:
	if not web_mode:
		print("[Godot]  Web platform not available.")
		return ""

	if not flutter_ready:
		print("[Godot]  Waiting for Flutter to become ready...")
		await flutter_readied
		print("[Godot]  Flutter is now ready!")

	print("[Godot]  Requesting dialog for:", speaker)

	# Send the request
	var js := "window.parent.postMessage({ type: 'dialog_request', speaker: '" + speaker + "' }, '*');"
	JavaScriptBridge.eval(js, true)

	# Await dialog response
	print("[Godot]  Waiting for dialog response for speaker:", speaker)

	var args = await dialog_received
	print("speaker: ", args[0])
	print("data: ", args[1])
	
	var result = args[1] if args != null else ""

	print("[Godot]  Dialog response received for ", speaker, ": ", result)
	return result
# Request the score from Flutter
#returns a score
#use like this:
#var score := await FlutterBridge.request_score()
func request_score() -> int:
	if not web_mode:
		print("[Godot]  Web platform not available.")
		return 0

	if not flutter_ready:
		print("[Godot]  Waiting for Flutter to become ready...")
		await flutter_readied
		print("[Godot]  Flutter is now ready!")

	print("[Godot]  Requesting score from Flutter...")

	# Send score request to Flutter
	var js := "window.parent.postMessage({ type: 'score_request' }, '*');"
	JavaScriptBridge.eval(js, true)

	# Wait for the score to be received
	var score = await score_received
	print("[Godot]  Score received: ", score)
	return score

func request_game() -> Dictionary:
	if not web_mode:
		print("[Godot] Web platform not available.")
		return {}

	if not flutter_ready:
		print("[Godot] Waiting for Flutter to become ready...")
		await flutter_readied
		print("[Godot] Flutter is now ready!")

	print("[Godot] Requesting game data from Flutter...")

	var js := "window.parent.postMessage({ type: 'game_request' }, '*');"
	JavaScriptBridge.eval(js, true)

	var data = await game_received
	print("[Godot] game data received: ", data)
	return data

#var result := await FlutterBridge.save_game()
func save_game(data: Dictionary) -> bool:
	if not web_mode:
		print("[Godot] Web platform not available.")
		return false

	if not flutter_ready:
		print("[Godot] Waiting for Flutter to become ready...")
		await flutter_readied
		print("[Godot] Flutter is now ready!")

	var payload = {
		"type": "save_game"
	}
	payload.merge(data, true)

	var json_str := JSON.stringify(payload)
	var js := "window.parent.postMessage(" + json_str + ", '*');"
	print("[Godot] Sending save game data to Flutter...")
	JavaScriptBridge.eval(js, true)

	print("[Godot] Awaiting game_saved from Flutter...")
	var result = await game_saved
	print("[Godot] Save result: ", result)
	return result
func quit_game () -> bool:
	if not web_mode:
		print("[Godot] Web platform not available.")
		return false

	if not flutter_ready:
		print("[Godot] Waiting for Flutter to become ready...")
		await flutter_readied
		print("[Godot] Flutter is now ready!")

	var js = "window.parent.postMessage({ type: 'quit_game'}, '*');"
	JavaScriptBridge.eval(js)

	print("[Godot] Awaiting game_quited from Flutter...")
	var result = await game_quited
	return result

# This function is called when a message is received from JavaScript
func _on_js_message(args: Array):
	# If no arguments were passed from JS, return early
	if args.size() == 0:
		print("[Godot]  No arguments passed from JS")
		return

	# Parse the JSON string received from JS
	var json_str: String = args[0]  # Explicitly declare the type as String
	var parsed = JSON.parse_string(json_str)

	# If the parsed data is a dictionary (valid JSON object), process it
	if parsed is Dictionary:
		match parsed.get("type", ""):
			# Handle Flutter ready signal
			"flutter_ready":
				print("[Godot]  Flutter is ready!")
				flutter_ready = true  # Set the flag that Flutter is ready
				emit_signal("flutter_readied")  # Emit signal to notify waiting functions
				request_dialog("Fysik")
				
			# Handle dialog data reception
			"dialog_response":
				var dialog_data: String = parsed.get("data", "")
				var speaker: String = parsed.get("speaker", "Unknown")

				if dialog_data is String:
					print("[Godot]  Dialog received for speaker:", speaker, "Data:", dialog_data)
					emit_signal("dialog_received", speaker, dialog_data)
				else:
					print("[Godot]  dialog_response data is not an array")
			"speakers_request":
				print("[Godot]  Available speakers: ", speakers)
				var speakers_json = JSON.stringify(speakers)
				print("[Godot]  Available speakers(JSON): ", speakers)
				var js = "window.parent.postMessage({ type: 'speakers_response', data: " + speakers_json + " }, '*');"
				JavaScriptBridge.eval(js)
			"score_response":
				var score_val = int(parsed.get("data", 0))
				print("[Godot]  Score response received: ", score_val)
				emit_signal("score_received", score_val)
			"game_response":
				var game_data = parsed.get("data", {})
				if game_data is Dictionary:
					print("[Godot] User data received: ", game_data)
					emit_signal("game_received", game_data)
				else:
					print("[Godot] game_response data is not a dictionary")
			"save_response":
				var success = bool(parsed.get("success", false))
				print("[Godot] Save game ACK received: ", success)
				emit_signal("game_saved", success)
			"quit_response":
				print("[Godot] Quit ACK reveived")
				var success = bool(parsed.get("success", false))
				print("[Godot] Quit game ACK received: ", success)
				emit_signal("game_quited", success)

				
	else:
		print("[Godot]  Failed to parse JSON")
