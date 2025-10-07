class_name Deadly_platform
extends Area2D

@export_range(0, 1000, 10, "suffix:deg/s") var rotation_speed: float = 200.0

@export_enum("Left:0", "Right:1") var start_direction: int = 0


func _process(delta: float) -> void:
	rotation_degrees += rotation_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		$SFX/PlayerHit.play()
		Global.lives -= 1
