extends Node


@export var pickup_scene : PackedScene
@export var obstacle_scene : PackedScene
@export var power_up_scene : PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_fruits()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
func spawn_fruits():
	var s = obstacle_scene.instantiate()
	add_child(s)
	s.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	for i in level + 4:
		var f = pickup_scene.instantiate()
		add_child(f)
		f.screensize = screensize
		f.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	$LevelSound.play()
	$PowerUpTimer.wait_time = randf_range(5, 10)
	$PowerUpTimer.start()
	
func _process(delta):
	if playing and get_tree().get_nodes_in_group("fruits").size() == 0:
		level += 1
		time_left += 10
		spawn_fruits()

func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left < 0:
		game_over()
	
func _on_player_hurt():
	game_over()
	
func _on_player_pickup(type):
	match type:
		"fruits":
			$FruitSound.play()
			score += 1
			$HUD.update_score(score)
		"powerups":
			$PowerUpSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
	
func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	get_tree().call_group("fruits", "queue_free")
	get_tree().call_group("obstacles", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_hud_start_game():
	new_game()

func _on_power_up_timer_timeout():
	var p = power_up_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
