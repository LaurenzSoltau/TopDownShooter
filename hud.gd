extends CanvasLayer

signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$messageTimer.start()
	

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	emit_signal("start_game")


func _on_message_timer_timeout():
	$Message.hide()


func show_game_over():
	show_message("Game Over")
	$messageTimer.stop()
	await get_tree().create_timer(2).timeout
	$Message.text = "Wave Shooter"
	$Message.show()
	await get_tree().create_timer(1).timeout
	$StartButton.show()
