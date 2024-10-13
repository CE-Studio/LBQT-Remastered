@icon("res://textures/ico/turret.svg")
extends RigidBody3D
class_name Turret


static var rounds:int = 50

@export var trackingOther := false
@export var others:Array[NodePath]
@export var lookID:int = 0

@onready var point:RayCast3D = $"base/mountarm/head/gun body/RayCast3D"
@onready var mount:MeshInstance3D = $base/mountarm
@onready var gun:Node3D = $"base/mountarm/head/gun body"
@onready var barrel:MeshInstance3D = $"base/mountarm/head/gun body/gun body/barrel"

var _other:Array

var spinup := false
var spinspeed := 0.0

func _ready():
	point.add_exception(self)
	for i in others:
		_other.append(get_node(i))


func _process(delta):
	if trackingOther:
		point.look_at(_other[lookID].global_position + Vector3(0, 0.3, 0), Vector3.UP, true)
		if point.is_colliding():
			if point.get_collider() == _other[lookID]:
				spinup = true
			else:
				spinup = false
		else:
			spinup = false
	else:
		point.look_at(Player.instance.global_position + Vector3(0, 0.3, 0), Vector3.UP, true)
		if point.is_colliding():
			if point.get_collider() == Player.instance:
				spinup = true
			else:
				spinup = false
		else:
			spinup = false
	if spinup:
		spinspeed += delta * 15
		if spinspeed > 15:
			spinspeed = 15
	else:
		spinspeed -= delta * 8
		if spinspeed < 0:
			spinspeed = 0
	barrel.rotate_y(spinspeed * delta)
	mount.rotate_y(lerpf(0, point.rotation.y, 5 * delta))
	gun.rotate_x(lerpf(0, point.rotation.x, 5 * delta))
