class_name Floating_platform
extends StaticBody2D

# FACTEUR DE MOUVEMENT (+1 ou -1)
@export_range(0, 1000, 10, "suffix:px/s") var speed: float = 200.0

@export_enum("Negative:-1", "Positive:1") var move_sign: int = 1 # Renommé pour éviter le conflit

@export_enum("Horizontal:0", "Vertical:1") var axis_move: int = 0

# VECTEUR DE MOUVEMENT (Vector2)
var current_direction: Vector2 = Vector2.ZERO # Renommé pour éviter le conflit
var is_horizontal: bool = true

@onready var _top_ray := $TopRay
@onready var _bottom_ray := $BottomRay
@onready var _left_ray := $LeftRay
@onready var _right_ray := $RightRay

func _ready() -> void:
	is_horizontal = (axis_move == 0)

func _process(delta: float) -> void:
	# 1. Mise à jour du vecteur de direction (Vector2) en fonction du facteur (+1/-1)
	match axis_move:
		0:  # Horizontal
			current_direction = Vector2(move_sign, 0)
		1:  # Vertical
			current_direction = Vector2(0, move_sign)

	#if Input.is_action_just_pressed("ui_up"):
		#change_direction()
	
	var should_change_direction = false
	
	if is_horizontal:
		if move_sign == -1 and _left_ray.is_colliding():
			should_change_direction = true
		elif move_sign == 1 and _right_ray.is_colliding():
			should_change_direction = true
	else: # Vertical
		if move_sign == -1 and _top_ray.is_colliding():
			should_change_direction = true
		elif move_sign == 1 and _bottom_ray.is_colliding():
			should_change_direction = true

	if should_change_direction:
		change_direction()
		
	position += current_direction * speed * delta

func change_direction():
	move_sign *= -1

func get_platform_velocity() -> Vector2:
	return current_direction * speed
