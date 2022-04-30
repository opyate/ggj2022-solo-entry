extends ColorRect


var flip = true

onready var tween = $Tween


func _ready():
	#warning-ignore:return_value_discarded
	tween.connect("tween_completed", self, "_on_tween_completed")
	_on_tween_completed(null, null)


func _on_tween_completed(_obj, _nodepath):
	flip = not flip
	
	if flip:
		tween.interpolate_property(self, "color", g.color_light, g.color_dark, 2.5)
	else:
		tween.interpolate_property(self, "color", g.color_dark, g.color_light, 2.5)
	tween.start()
