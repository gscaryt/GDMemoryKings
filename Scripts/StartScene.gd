extends CenterContainer

onready var manager : Node2D = get_parent()
onready var SFX : = manager.get_node("SFX")
onready var game : Node2D = get_parent().get_node("Game")
onready var board : Node2D = game.get_node("Board")

func _on_1_pressed():
	SFX.get_node("ButtonClick").play()
	game.playersNumber = 1

func _on_2_pressed():
	SFX.get_node("ButtonClick").play()
	game.playersNumber = 2

func _on_3_pressed():
	SFX.get_node("ButtonClick").play()
	game.playersNumber = 3

func _on_4_pressed():
	SFX.get_node("ButtonClick").play()
	game.playersNumber = 4

func _on_GridSizeTog_pressed():
	SFX.get_node("TogClick").play()
	if game.gridSize == Vector2(5,5):
		game.gridSize = Vector2(6,6)
	else:
		game.gridSize = Vector2(5,5)

func _on_SetupVariantTog_pressed():
	SFX.get_node("TogClick").play()
	if game.setupVariant == "Standard":
		game.setupVariant = "Alternate"
	else:
		game.setupVariant = "Standard"

func _on_StartLogo_pressed():
	SFX.get_node("ButtonClick").play()
	yield(manager.transition(self, game), "completed")
	board.deck = board.genDeck()
	board.buildBoard()
	game.genPlayers()
