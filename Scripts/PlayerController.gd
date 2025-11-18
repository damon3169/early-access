extends CharacterBody3D
@onready var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002
var movement_speed: float = 2
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
var isRotating=false
var _target_angle =0.0
var _rotation_amount =0
var movingDirection 

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
		if snapped(abs(rotation_degrees.y),1) ==0:
			movingDirection=Vector3i(input.x,0.0,input.y)
		elif snapped(abs(rotation_degrees.y),1) ==90:
			movingDirection=Vector3i(input.y*sign(rotation_degrees.y),0.0,input.x*sign(rotation_degrees.y)*-1)
			print(movingDirection)
		elif snapped(abs(rotation_degrees.y),1) ==180:
			movingDirection=Vector3i(-input.x,0.0,-input.y)
		elif snapped(abs(rotation_degrees.y),1) ==270:
			movingDirection=Vector3i(input.x*sign(rotation_degrees.y),0.0,input.y*sign(rotation_degrees.y))
		if (gridMapArray.has(myCell+movingDirection)):
			moving = true
			myCell+=Vector3i(movingDirection)
			set_movement_target(gridMap.map_to_local(myCell))

func _physics_process(delta):
	if isRotating:
		rotation_degrees=rotation_degrees.lerp(_target_angle,_rotation_amount)
		_rotation_amount +=delta
		if (rotation_degrees == _target_angle):
			isRotating=false
			if rotation_degrees.y == 360 || rotation_degrees.y ==-360:
				rotation_degrees.y =0
		
	if current_path.is_empty():
		return
	if moving:
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
		
	
			
func _input(event):
	if event.is_action_pressed("mouse_switch"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE



func _on_area_2d_grab_movement(input: Vector2) -> void:
	if !moving:
		moveCharacter(input)
	pass # Replace with function body.


func _on_rotation_lever_grab_rotation(input: float) -> void:
	if !isRotating:
		_target_angle = rotation_degrees + Vector3(0,90*input*-1,0)
		isRotating=true
		_rotation_amount = 0.0
	pass # Replace with function body.
