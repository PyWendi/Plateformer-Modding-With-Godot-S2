class_name Key extends Node


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		Global._key_collected()
		queue_free()
