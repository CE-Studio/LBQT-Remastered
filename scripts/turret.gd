@icon("res://textures/ico/turret.svg")
extends RigidBody3D
class_name Turret


static var rounds:int = 50

@export var trackingOther := false
@export var others:Array[NodePath]
@export var lookID:int = 0

@onready var point := $"base/mountarm/head/gun body/RayCast3D"
@onready var mount := $base/mountarm
@onready var gun := $"base/mountarm/head/gun body"

var _other:Array

func _ready():
    for i in others:
        _other.append(get_node(i))


func _process(delta):
    if trackingOther:
        point.look_at(_other[lookID].global_position + Vector3(0, 0.3, 0), Vector3.UP, true)
    else:
        point.look_at(Player.instance.global_position + Vector3(0, 0.3, 0), Vector3.UP, true)
    mount.rotate_y(lerpf(0, point.rotation.y, 5 * delta))
    gun.rotate_x(lerpf(0, point.rotation.x, 5 * delta))
    
