extends Node3D
class_name Antline


@export var chainOut:Antline
@export var threshold:int = 0


var count:int = 0


var tube:MeshInstance3D
var plug1:MeshInstance3D
var plug2:MeshInstance3D
var lights:MeshInstance3D


var off_t:StandardMaterial3D = preload("uid://cpqsirxu2mcr0")
var off_s:StandardMaterial3D = preload("uid://modqfo6u5wsb")
var on_t:StandardMaterial3D = preload("uid://dsasls5yivf8e")
var on_s:StandardMaterial3D = preload("uid://c1mn2pbsyajgt")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tube = get_child(0)
	plug1 = tube.get_child(0)
	plug2 = tube.get_child(1)
	lights = tube.get_child(2)
	tube.material_override = off_t
	lights.material_override = off_s
	plug1.material_override = preload("uid://bnfuvf6sh4gcw")
	plug2.material_override = plug1.material_override


func update():
	if count > threshold:
		tube.material_override = on_t
		lights.material_override = on_s
	else:
		tube.material_override = off_t
		lights.material_override = off_s


func connectionOn():
	if is_instance_valid(chainOut):
		chainOut.connectionOn()
	count += 1
	update()


func connectionOff():
	if is_instance_valid(chainOut):
		chainOut.connectionOff()
	count -= 1
	update()
