@icon("res://textures/ico/cube.svg")
extends RigidBody3D
class_name  Cube


@onready var aud := $AudioStreamPlayer3D


func _on_body_entered(body):
    aud.play()
