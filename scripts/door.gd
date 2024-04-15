@icon("res://textures/ico/door.svg")
extends Node3D
class_name Door


@export var threshold:int = 0
var count:int = 0
@onready var animTree := $AnimationTree


func connectionOn() :
	count += 1
	animTree["parameters/conditions/close"] = count <= threshold
	animTree["parameters/conditions/open"] = count > threshold


func connectionOff() :
	count -= 1
	animTree["parameters/conditions/close"] = count <= threshold
	animTree["parameters/conditions/open"] = count > threshold
