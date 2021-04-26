extends Node

const levels = {
	"Level1":"res://Levels/Level2.tscn",
	"Level2":"res://Levels/Level3.tscn",
	"Level3":"res://Levels/Level4.tscn",
	"Level4":"res://Levels/LevelEnd.tscn",
	"LevelEnd":"res://Levels/Level2.tscn",
}

func next_level(current):
	return levels[current]
