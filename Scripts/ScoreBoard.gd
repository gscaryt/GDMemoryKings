extends HBoxContainer

onready var game := get_parent()
onready var manager := game.get_parent()
onready var board := game.get_node("Board")
onready var _playerScore := preload("res://Scenes/PlayerScore.tscn")
onready var showScores : Array = []

func loadScoreBoard():
	for i in range(game.playersNumber):
		var plScore = _playerScore.instance()
		showScores.append(plScore)
		add_child(plScore)
		var _sprite = load("res://Sprites/Pawns/pawn_" + str(game.players[i].color.to_lower()) + ".png")
		plScore.get_node("Pawns").get_node("1").texture = _sprite
		plScore.get_node("Pawns").get_node("2").texture = _sprite
		plScore.get_node("Pawns").visible = true
		plScore.get_node("Color").text = game.playerColors[i]
		plScore.get_node("Color").add_color_override("font_color", game.playerColorsRGB[i])
		plScore.get_node("Score").text = String(game.players[i].score)
		plScore.get_node("Score").add_color_override("font_color", game.playerColorsRGB[i])
		plScore.visible = true
	if game.playersNumber == 1:
		var counter = _playerScore.instance()
		showScores.append(counter)
		add_child(counter)
		var _counterSprite = load("res://Sprites/Pawns/pawn_" + str(game.players[-1].color.to_lower()) + ".png")
		counter.get_node("Pawns").get_node("1").texture = _counterSprite
		counter.get_node("Pawns").get_node("2").texture = _counterSprite
		counter.get_node("Pawns").visible = true
		counter.get_node("Pawns").get_node("2").visible = false
		counter.get_node("Color").text = "COUNTER"
		counter.get_node("Color").add_color_override("font_color", game.playerColorsRGB[-1])
		counter.get_node("Score").text = String(game.players[-1].score)
		counter.get_node("Score").add_color_override("font_color", game.playerColorsRGB[-1])
		counter.visible = true
	manager.scoresReady = true
	showScores[0].get_node("Current").visible = true

