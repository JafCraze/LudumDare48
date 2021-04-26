extends Area2D

signal Hit
var points = 0
export(int) var required = 1

func _ready():
	$Anim.play("Drop")
	if required >= 1:
		$Ring1.show()
	if required >= 2:
		$Ring2.show()

func _on_Target_body_entered(body):
	if points == required: 
		return
	if body.is_in_group("Ball"):
		body.queue_free()
		points += 1
		check_rings()
		emit_signal("Hit")

func check_rings():
	$Ring2.hide()
	
	if points == required:
		$Ring1.hide()
		$Anim.play_backwards("Drop")
		$Col.set_deferred("disabled", true)
		$HitSFX.play()

func full():
	return points == required

func _process(delta):
	$Sprite.rotation_degrees += 100 * delta
	$Ring1.rotation_degrees -= 50 * delta
	$Ring2.rotation_degrees += 50 * delta
