extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var isGrabing = true
signal grabMovement(input: Vector2)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if !isGrabing:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	else:
		grabMovement.emit(Input.get_vector("left", "right", "forward", "back"))
	move_and_slide()
	isGrabing=false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if (collision.get_collider().is_in_group("Grabable")):
			if Input.is_action_pressed("grab"):
				isGrabing = true
