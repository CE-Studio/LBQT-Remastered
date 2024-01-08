@icon("res://textures/ico/cubebutton.svg")
extends Area3D
class_name CubeButton


@export var count:int = 0
@export var connections:Array[Node]

@onready var plate := $Cube_001
@onready var aud := $AudioStreamPlayer3D


func press():
    plate.position = Vector3(0, -0.048, 0)
    for i in connections:
        if i.has_method("connectionOn"):
            i.connectionOn()
    aud.stream = preload("res://sound/button/padOn.wav")
    aud.play()
            
            
func unpress():
    plate.position = Vector3.ZERO
    for i in connections:
        if i.has_method("connectionOff"):
            i.connectionOff()
    aud.stream = preload("res://sound/button/padOff.wav")
    aud.play()


func _on_body_entered(body):
    if body.is_in_group("heavy"):
        if count == 0:
            press()
        count += 1


func _on_body_exited(body):
    if body.is_in_group("heavy"):
        count -= 1
        if count == 0:
            unpress()
