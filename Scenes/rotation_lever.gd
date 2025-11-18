extends grabbableObject

signal grabRotation(input: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isGrabed:
		if (Input.get_axis("left", "right")!=0.0):
			grabRotation.emit(Input.get_axis("left", "right"))
	pass
