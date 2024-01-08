extends RigidBody3D
class_name Portal


var vp:Viewport
var svp:SubViewport
var transformer:Node3D
var other:Portal
var cam:Camera3D
var aud:AudioStreamPlayer3D


func _ready() -> void:
    vp = get_viewport()
    vp.size_changed.connect(resize)
    svp = $SubViewport
    transformer = $"Node3D"
    if name == "orange":
        other = $"../blue"
    else:
        other = $"../orange"
    cam = $SubViewport/Camera3D
    aud = $AudioStreamPlayer3D


func resize():
    svp.size = vp.get_visible_rect().size


func _process(_delta):
    transformer.global_transform = Player.instance.cam.global_transform
    transformer.position *= Vector3(-1, 1, -1)
    transformer.rotation_degrees.y += 180
    other.transformer.transform = transformer.transform
    other.cam.global_transform = other.transformer.global_transform


func _on_body_entered(body):
    aud.play()
