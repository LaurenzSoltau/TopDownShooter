extends Node

func play_ui_sound():
	$UiClick.pitch_scale = randf_range(0.8, 1.2)
	$UiClick.play()

func play_ui_error():
	$UiError.pitch_scale = randf_range(0.8, 1.2)
	$UiError.play()
