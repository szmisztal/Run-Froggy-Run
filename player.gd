extends Area2D
signal pickup
signal hurt


@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)

func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"
	
func _process(delta):
	velocity = Vector2(0, 0)
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1
		
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)


	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false) 

func _on_area_entered(area):
	if area.is_in_group("fruits"):
		area.pickup()
		pickup.emit("fruits")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerups")
	if area.is_in_group("obstacles"):
		area.hurt()
		die()
