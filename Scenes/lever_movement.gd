extends grabbableObject

signal grabMovement(input: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isGrabed:
		grabMovement.emit(Input.get_vector("left", "right", "forward", "back"))

	pass


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
