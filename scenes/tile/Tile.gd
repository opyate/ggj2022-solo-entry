extends Node2D

onready var rect = $Rect

var color = Color.black setget color_set

func _ready():
	rect.rect_size.x = g.TILE_SIZE
	rect.rect_size.y = g.TILE_SIZE


func color_set(new_value: Color):
	color = new_value


func white():
	rect.color = Color.white


func black():
	rect.color = Color.black

