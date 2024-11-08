@icon("res://textures/ico/player.svg")
extends CharacterBody3D
class_name Player


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GROUNDACCEL = 20.0
const AIRACCEL = 7.0


static var instance:Player


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var cam:Camera3D = $Camera3D
@onready var ray:RayCast3D = $Camera3D/RayCast3D
@onready var parent:Node3D = $"../"
@onready var grab:Node3D = $Camera3D/grabpoint


func _ready() -> void:
	instance = self


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_action_raw_strength("rotate") > 0.1:
			if grab.get_child_count() > 0:
				grab.get_child(0).apply_torque(Vector3(event.relative.y, event.relative.x, 0) / 10)
		else:
			rotate_y(event.relative.x / -300)
			cam.rotate_x(event.relative.y / -300)
			cam.rotation_degrees.x = clampf(cam.rotation_degrees.x, -90, 90)
	elif event.is_action_pressed("interact"):
		if grab.get_child_count() > 0:
			var obj = grab.get_child(0)
			var trans = Transform3D(obj.global_transform)
			grab.remove_child(obj)
			obj.axis_lock_linear_x = false
			obj.axis_lock_linear_y = false
			obj.axis_lock_linear_z = false
			obj.collision_layer = 0b1
			obj.collision_mask = 0b1
			parent.add_child(obj)
			obj.global_transform = trans
		elif ray.is_colliding():
			var obj = ray.get_collider()
			if obj.is_in_group("grab"):
				obj.get_parent().remove_child(obj)
				grab.add_child(obj)
				obj.linear_velocity = Vector3.ZERO
				obj.position = Vector3.ZERO
				obj.axis_lock_linear_x = true
				obj.axis_lock_linear_y = true
				obj.axis_lock_linear_z = true
				obj.collision_layer = 0b0
				obj.collision_mask = 0b0
			elif obj.is_in_group("press"):
				if obj.has_method("press"):
					obj.press()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var tv := Vector2(velocity.x, velocity.z)
		var td := Vector2(direction.x * SPEED, direction.z * SPEED)
		if is_on_floor():
			if tv != Vector2.ZERO and abs(tv.angle_to(td)) > 2.0:
				tv = Vector2.ZERO
			else:
				tv = tv.move_toward(td, delta * GROUNDACCEL)
		else:
			tv = tv.move_toward(td, delta * AIRACCEL)
		velocity.x = tv.x
		velocity.z = tv.y
	elif is_on_floor():
		var tv := Vector2(velocity.x, velocity.z)
		tv = tv.move_toward(Vector2.ZERO, delta * GROUNDACCEL)
		velocity.x = tv.x
		velocity.z = tv.y

	if grab.get_child_count() > 0:
		grab.get_child(0).position = Vector3.ZERO

	move_and_slide()
