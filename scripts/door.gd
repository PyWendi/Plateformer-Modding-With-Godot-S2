class_name Door extends Area2D

@onready var sprite:AnimatedSprite2D = $AnimatedSprite2D
@onready var detector:CollisionShape2D = $Detector
@onready var collision:CollisionShape2D = $"../CollisionShape2D"


func _ready() -> void:
	sprite.play("close")
	detector.disabled = false
	collision.disabled = false


func _on_body_entered(body: Node) -> void:
	print("Body entered")
	if body.is_in_group("players"):
		if Global.keys > 0:
			print("Inside opened")
			sprite.play("open")
			detector.set_deferred("disabled", true)
			collision.set_deferred("disabled",true) 
			Global._key_used()
			$"../AudioStreamPlayer".play()
