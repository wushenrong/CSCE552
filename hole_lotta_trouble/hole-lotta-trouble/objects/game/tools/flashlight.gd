extends StaticBody3D


@onready var light: SpotLight3D = $"SpotLight3D"


func use():
	if not light.visible:
		light.visible = true
	else:
		light.visible = false
