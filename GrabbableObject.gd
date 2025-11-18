extends Area2D
class_name grabbableObject

var isGrabed = false

func _physics_process(delta: float) -> void:
	isGrabed=false
	for i in get_overlapping_bodies():
		if (i.is_in_group("Player")):
			if Input.is_action_pressed("grab"):
				isGrabed = true
				i.isGrabing = true
				
