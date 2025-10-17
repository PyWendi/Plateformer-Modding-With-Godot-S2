class_name FlyingEnnemy
extends CharacterBody2D

## How fast does your enemy move?
@export_range(0, 1000, 10, "suffix:px/s") var speed: float = 100.0:
	set = _set_speed
var initial_speed: float = 0

## Does the enemy fall off edges?
@export var fall_off_edge: bool = false

## Does the player lose a life when contacting the enemy?
@export var player_loses_life: bool = true

## Can the enemy be squashed by the player?
@export var squashable: bool = true

## Can the enemy be squashed but not kill the player?
@export var squashable_stomp: bool = false

# can double speed?
@export var double_speed: bool = false
var has_speed_doubled := false


## The direction the enemy will start moving in.
@export_enum("Left:0", "Right:1") var start_direction: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: int

@onready var _sprite := %AnimatedSprite2D
@onready var _left_ray := %LeftRay
@onready var _right_ray := %RightRay
@onready var hit_box_collider:CollisionShape2D = $Hitbox/CollisionShape2D
@onready var collision_collider:CollisionShape2D = $CollisionShape2D


func _set_speed(new_speed):
	speed = new_speed
	if not is_node_ready():
		await ready
	if speed == 0:
		_sprite.speed_scale = 0
	else:
		_sprite.speed_scale = speed / 100
		initial_speed = speed
		


func _ready():
	Global.gravity_changed.connect(_on_gravity_changed)
	initial_speed = speed
	hit_box_collider.disabled = false
	collision_collider.disabled = false
	
	direction = -1 if start_direction == 0 else 1


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if not fall_off_edge and (_left_ray.is_colliding() or _right_ray.is_colliding()):
		if direction == -1 and not _left_ray.is_colliding():
			direction = 1
		elif direction == 1 and not _right_ray.is_colliding():
			direction = -1

	velocity.x = direction * speed

	_sprite.flip_h = velocity.x < 0

	move_and_slide()

	if velocity.x == 0 and is_on_floor():
		direction *= -1


func _on_gravity_changed(new_gravity):
	gravity = new_gravity

func _on_hitbox_body_entered(body):
	if body.is_in_group("players"):
		if squashable and body.velocity.y > 0 and body.position.y < position.y:
			body.stomp()
			if not squashable_stomp:
				_sprite.play("hit")
				hit_box_collider.set_deferred("disabled", true)
				#collision_collider.set_deferred("disabled", true)
				speed = 0
				#queue_free()
			else :
				if not has_speed_doubled and double_speed:
					speed *= 2
					has_speed_doubled = true
		elif player_loses_life:
			if Global.lives > 0:
				$SFX/PlayerHit.play()
			Global.lives -= 1
