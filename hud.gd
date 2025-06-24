extends CanvasLayer

signal start_game

func update_score(value):
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	$MarginContainer/Time.text = str(value)
	
func show_messages(text):
	$Message.text = text
	$Message.show()
	$Timer.start()

func _on_timer_timeout():
	$Message.hide()


func _on_button_pressed():
	$Button.hide()
	$Message.hide()
	start_game.emit()
	
func show_game_over():
	show_messages("Game Over")
	await $Timer.timeout
	$Button.show()
	$Message.text = "Run Froggy Run !"
	$Message.show()
