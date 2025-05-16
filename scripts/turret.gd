@icon("res://textures/ico/turret.svg")
extends RigidBody3D
class_name Turret


static var rounds:int = 300
static var bullet:PackedScene = preload("res://parts/bullet.tscn")

@export var trackingOther := false
@export var others:Array[NodePath]
@export var lookID:int = 0

@onready var point:RayCast3D = $"base/mountarm/head/gun body/RayCast3D"
@onready var mount:MeshInstance3D = $base/mountarm
@onready var gun:Node3D = $"base/mountarm/head/gun body"
@onready var barrel:MeshInstance3D = $"base/mountarm/head/gun body/gun body/barrel"
@onready var bpoint:Marker3D = $"base/mountarm/head/gun body/Marker3D"
@onready var worldspace:Node3D = get_parent()

var _other:Array

var spinup := false
var spinspeed := 0.0
var firetime := 0.0

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
				if rounds > 0 and spinspeed == 15:
					firetime += delta
					if firetime >= 0.1:
						rounds -= 1
						firetime -= 0.1
						var b:RigidBody3D = bullet.instantiate()
						worldspace.add_child(b)
						b.global_rotation = bpoint.global_rotation
						b.global_position = bpoint.global_position
						b.apply_central_impulse(b.global_transform.basis * Vector3(0, 30, 0))
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
