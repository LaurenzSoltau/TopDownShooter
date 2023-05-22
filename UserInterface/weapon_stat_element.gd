extends HBoxContainer

func change_value(stat_name, stat_value):
	$StatName.text = stat_name
	$StatValue.text = str(stat_value)
