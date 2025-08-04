class_name PlayerManager
extends Node2D

var PLAYER_SCENE = preload("uid://bdqcutktqtcxw")

var player: Player


func _ready() -> void:
	DI.register("_player_manager", self)
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	
