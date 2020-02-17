extends Node2D

var dict = {}


func _ready():
	$StartDelay.start(1)

func _on_StartDelay_timeout():
	Save.load_app()

