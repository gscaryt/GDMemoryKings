extends Node2D

onready var background := get_node("Background")

# Scenes:
onready var startScene := get_node("StartScene")
onready var gameScene := get_node("Game")
# onready var aboutScene := get_node("AboutScene")
# onready var endScene := get_node("EndScene")
# onready var rulesScene := get_node("RulesScene")

# Utility
onready var _trans := get_node("SceneTransition")

# States
onready var isSolo : bool
onready var boardReady : bool
onready var scoresReady : bool
onready var counterSet : bool
onready var allPawnsSet : bool
onready var isFinished : bool
onready var pause : bool

# Scenes Dictionary
onready var scenes : = {
	startScene: true,
	gameScene: false,
	}
	
func transition(oldScene, newScene):
	_trans.visible = true
	_trans.get_node("Animation").play("FadeOut") 
	yield(get_tree().create_timer(0.25), "timeout")
	scenes[oldScene] = false
	oldScene.visible = false
	_trans.get_node("Animation").play("FadeIn")
	yield(get_tree().create_timer(0.25), "timeout")
	scenes[newScene] = true
	newScene.visible = true
	_trans.visible = false

