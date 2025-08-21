extends Node

@export var texto: String
@onready var panel = $Panel
@onready var label: RichTextLabel = $Panel/RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	panel.visible = false
	label.text = texto

func _on_body_entered(body):
	if body.is_in_group("player"):
		panel.visible = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		panel.visible = false
#prueba


