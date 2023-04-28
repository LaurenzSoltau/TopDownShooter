extends HBoxContainer

@export var icon: AtlasTexture
@export var stat_key: String
@export var stat_name: String


func _ready():
	$StatName.text = stat_name
	$TextureRect.texture = icon


func change_value(new_value):
	print(new_value)
	if stat_key == "damage_percent":
		$StatValue.text = "%s" % str(new_value)
	$StatValue.text = str(new_value)
	
