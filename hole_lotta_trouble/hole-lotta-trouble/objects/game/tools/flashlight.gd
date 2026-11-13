extends Tool


@onready var light: SpotLight3D = $SpotLight3D


func use():
	if not light.visible:
		light.show()
		$FlashlightSFX/FlashlightOn.play()
	else:
		light.hide()
		$FlashlightSFX/FlashlightOff.play()
