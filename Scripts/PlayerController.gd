extends CharacterBody3D
@onready var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002
var movement_speed: float = 4.0
var movement_delta: float
var path_point_margin: float = 0.1

var current_path_index: int = 0
var current_path_point: Vector3
var current_path: PackedVector3Array
var moving = false
var cellLength = 1
var myCell = Vector3i.ZERO
var gridMap 
var gridMapArray
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	gridMap = $"../NavigationRegion3D/GridMap"
	gridMapArray=gridMap.get_used_cells()
	
func set_movement_target(target_position: Vector3):

	var start_position: Vector3 = global_transform.origin

	current_path = NavigationServer3D.map_get_path(
		default_3d_map_rid,
		start_position,
		target_position,
		true
	)
	if not current_path.is_empty():
		current_path_index = 0
		current_path_point = current_path[0]
		

func moveCharacter(input:Vector2):
	if input != Vector2.ZERO  && !moving:
		if (gridMapArray.has(myCell+Vector3i(input.x,0.0,input.y))):
			moving = true
			myCell+=Vector3i(input.x,0.0,input.y)
			set_movement_target(gridMap.map_to_local(myCell))

func _physics_process(delta):
	
	if current_path.is_empty():
		return

	movement_delta = movement_speed * delta

	if global_transform.origin.distance_to(current_path_point) <= path_point_margin:
		current_path_index += 1
		if current_path_index >= current_path.size():
			current_path = []
			current_path_index = 0
			current_path_point = global_transform.origin
			moving=false	
			return
			
	current_path_point = current_path[current_path_index]

	var new_velocity: Vector3 = global_transform.origin.direction_to(current_path_point) * movement_delta

	global_transform.origin = global_transform.origin.move_toward(global_transform.origin + new_velocity, movement_delta)
#if is_on_floor() and Input.is_action_just_pressed("jump"):
		#velocity.y = jump_speed
func _input(event):
	if event.is_action_pressed("mouse_switch"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))


func _on_player_1_grab_movement(input: Vector2) -> void:
	moveCharacter(input)
	pass # Replace with function body.
