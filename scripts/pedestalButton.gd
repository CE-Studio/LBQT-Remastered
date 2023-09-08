@icon("res://textures/ico/ped.svg")
extends Area3D
class_name PedestalButton

@export var timeout:float = 1
@export var connections:Array[Node]
@export var oneshot := false

@onready var time := $Timer
@onready var paddle := $Cube_002/Cube_003


func press():
    if time.is_stopped():
        time.start(timeout)
        paddle.position = Vector3(0, 0.052, 0)
        for i in connections:
            if i.has_method("connectionOn"):
                i.connectionOn()
    else:
        print("aaa")
                
                
func unpress():
    if !oneshot:
        time.stop()
        paddle.position = Vector3(0, 0.082, 0)
        for i in connections:
            if i.has_method("connectionOff"):
                i.connectionOff()


func _on_body_entered(body):
    if body.name != "player":
        press()
