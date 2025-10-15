class_name Hints extends Control

@onready var hint: Label = %HintText
@onready var panel: Panel = $Panel

@export var hint_text: String : 
	set = _set_hint_text

func _set_hint_text(new_text):
	hint_text = new_text 
	if is_node_ready():
		hint.text = str(new_text)
		
func _ready() -> void:
	hint.text = hint_text
	panel.hide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		panel.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		panel.hide()
