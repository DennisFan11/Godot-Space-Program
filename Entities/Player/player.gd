class_name Player
extends Node

var position: Vector2:
	get: return %CharacterBody2D.position
	set(new):
		position = new
		%CharacterBody2D.position = new
