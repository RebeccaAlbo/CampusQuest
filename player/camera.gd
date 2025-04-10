extends Camera3D

@onready var ground_mesh: MeshInstance3D = get_node("/root/world/ground")  # Adjust path as needed

func _ready() -> void:
	# Get the vertical distance to the ground and adjust the near plane
	var distance_to_ground = get_distance_to_ground()
	
	# 🔧 TUNE THESE VALUES:
	var distance_multiplier = 0.5  # 👈 Multiplies the ground distance to set near clip. Lower = closer near plane
	var min_near = 0.1             # 👈 Smallest allowed near plane value. Avoids clipping close objects
	var max_near = 2.0             # 👈 Largest allowed near plane. Prevents precision loss at distance

	# Set the new near clipping plane based on the ground distance
	self.near = clamp(distance_to_ground * distance_multiplier, min_near, max_near)

	print("Distance to ground:", distance_to_ground)
	print("Camera near plane set to:", self.near)

# ✅ Function to measure vertical distance to the ground MeshInstance3D
func get_distance_to_ground() -> float:
	var cam_y = global_transform.origin.y
	var ground_y = ground_mesh.global_transform.origin.y  # Access the global Y position of the MeshInstance3D

	# Prevent returning a negative distance in case the camera is below the ground
	return max(cam_y - ground_y, 0.1)
