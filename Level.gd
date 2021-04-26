extends Node2D

export(PackedScene) var Ball
export(PackedScene) var Target
export(PackedScene) var Explosion

var current_ball : KinematicBody2D
const laser_length := 200.0

func _ready():
	if get_node_or_null("CanvasLayer/LabelLeft"):
		get_node_or_null("CanvasLayer/LabelLeft").hide()
	if get_node_or_null("CanvasLayer/LabelRight"):
		get_node_or_null("CanvasLayer/LabelRight").hide()
	$TileMap.hide()
	randomize()
	yield(get_tree().create_timer(0.5), "timeout")
	$Anim.play("ShowRed")

func target_hit():
	for target in $Targets.get_children():
		if !target.full():
			return
	
	yield(get_tree().create_timer(0.5), "timeout")
	$Anim.play("HideHalf")

func _on_Anim_animation_finished(anim_name):
	if anim_name == "ShowRed":
		for pos in $TargetPos.get_children():
			var target = Target.instance()
			target.global_position = pos.global_position
			target.connect("Hit", self, "target_hit")
			$Targets.add_child(target)
		
		for pos in $BallPos.get_children():
			var ball = Ball.instance()
			ball.global_position = pos.global_position
			ball.connect("Pressed", self, "ball_pressed", [ball])
			ball.connect("Dead", self, "ball_dead")
			$Balls.add_child(ball)
	elif anim_name == "HideHalf":
		get_tree().change_scene(GameData.next_level(name))

func ball_pressed(ball):
	current_ball = ball
	$Laser.show()

func ball_dead(pos):
	var explosion = Explosion.instance()
	explosion.global_position = pos
	add_child(explosion)
	explosion.emitting = true
	$ExplosionSFX.play()

func _process(_delta):
	if current_ball != null:
		var dir = get_global_mouse_position().direction_to(current_ball.global_position)
		var pos1 = current_ball.global_position + dir * laser_length / 4
		var pos2 = current_ball.global_position + dir * laser_length
		$Laser.set_point_position(0, pos1)
		$Laser.set_point_position(1, pos2)

func _unhandled_input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()

	if event.is_action_pressed("ui_accept"):
		$Anim.play("HideHalf")
	
	if event.is_action_released("click"):
		$Laser.hide()
		if current_ball != null:
			current_ball.move()
		current_ball = null
