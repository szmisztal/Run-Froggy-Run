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
	# new_game()
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_fruits()
	
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
