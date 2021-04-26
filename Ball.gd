extends KinematicBody2D

signal Pressed
signal Dead
var speed = 500.0
var velocity = Vector2()
var can_move := false
var bounces := 0

func _ready():
	$Anim.play("Drop")

func move():
	var dir = get_global_mouse_position().direction_to(global_position).angle()
	velocity = Vector2(speed, 0).rotated(dir)
	can_move = true

func freeze():
	can_move = false
	velocity = Vector2()

func _physics_process(delta):
	if can_move:
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.normal)
			bounces += 1
			$Anim.play("Hurt")
			if bounces > 2:
				emit_signal("Dead", global_position)
				queue_free() #explode

func _on_Drag_input_event(_viewport, event, _shape_idx):
	if can_move:
		return
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("Pressed")
