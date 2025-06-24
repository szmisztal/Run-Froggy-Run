extends Node


@export var pickup_scene : PackedScene
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
	for i in level + 4:
		var f = pickup_scene.instantiate()
		add_child(f)
		f.screensize = screensize
		f.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

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
	
func _on_player_pickup():
	score += 1
	$HUD.update_score(score)
	
func game_over():
	playing = false
	$Timer.stop()
	get_tree().call_group("fruits", "queue_free")
	$HUD.show_game_over()
	$Player.die()

func _on_hud_start_game():
	new_game()
