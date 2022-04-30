extends ColorRect

const color1: Color = Color("#1896eb")
const color2: Color = Color("#511900")
var flip = true

onready var tween = $Tween


func _ready():
	#warning-ignore:return_value_discarded
	tween.connect("tween_completed", self, "_on_tween_completed")
	_on_tween_completed(null, null)


func _on_tween_completed(_obj, _nodepath):
	flip = not flip
	
	if flip:
		tween.interpolate_property(self, "color", color1, color2, 2.5)
	else:
		tween.interpolate_property(self, "color", color2, color1, 2.5)
	tween.start()
