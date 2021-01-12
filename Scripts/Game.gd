extends Node2D

export var playersNumber : int = 1 # "1" to "4"
export var gridSize : Vector2 = Vector2(5,5)
export var setupVariant : String = "Standard"

onready var _player : = preload("res://Scenes/Player.tscn")

onready var manager : = get_parent()
onready var board : = get_node("Board")
onready var scoreBoard : = get_node("ScoreBoard")

var PURPLE : Color = Color8(92, 45, 129)
var ORANGE : Color = Color8(228,113,19)
var WHITE : Color = Color8(211, 208, 188)
var BLACK : Color = Color8(40, 40, 40)
var BROWN : Color = Color8(97, 48, 0)

var players : Array = []
var playerColors : Array = ["PURPLE", "ORANGE", "WHITE", "BLACK", "BROWN"]
var playerColorsRGB : Array = [PURPLE, ORANGE, WHITE, BLACK, BROWN]

onready var currentTurn : int = 0

var winner : String

func genPlayers() -> void:
	# Creates all human Players.
	for i in range(playersNumber):
		players.append(_player.instance())
		players[i].color = playerColors[i]
		players[i].orderNumber = i
		board.add_child(players[i])
		
	# If Solo, create Counter King
	if playersNumber == 1:
		players.append(_player.instance())
		players[-1].color = playerColors[-1]
		players[-1].orderNumber = 1
		players[-1].isCounter = true
		board.add_child(players[-1])
	
	# Set first player
	players[currentTurn].isTurn = true

func changeTurn() -> void:
	# Must be called after a player succesfully executes their turn.
	players[currentTurn].isTurn = false
	scoreBoard.showScores[currentTurn].get_node("Current").visible = false
	if playersNumber == 1:
		currentTurn = (currentTurn+1)%2
	else:
		currentTurn = (currentTurn+1)%playersNumber
	print("Current Player: " + players[currentTurn].color)
	scoreBoard.showScores[currentTurn].get_node("Current").visible = true
	players[currentTurn].isTurn = true

func placePawns() -> void:
	# Calls method placePawn() of each player until all players have 2 pawns.
	if manager.boardReady and not manager.allPawnsSet:
		if players[currentTurn].placePawn():
			if playersNumber == 1 and players[0].pawns.size() == 2:
				manager.allPawnsSet = true
			elif players[-1].pawns.size() == 2:
				manager.allPawnsSet = true
			if not playersNumber == 1:
				changeTurn()

func isEndGame() -> bool:
	# Checks for End Game conditions.
	if playersNumber == 1 and players[-1].pawns[0].gridPos == gridSize - Vector2(1,1):
		manager.isFinished = true
		winner = players[-1].color
		print("Winner:" + players[-1].color)
		return true
	else:
		for player in players:
			if player.score == 12/players.size():
				manager.isFinished = true
				winner = player.color
				print("Winner: " + player.color)
				return true
		return false
	
func _process(delta):
	board.displayCards()
	if not manager.pause:
		if manager.boardReady:
			if not manager.scoresReady:
				scoreBoard.loadScoreBoard()
			if playersNumber == 1 and players[-1].pawns.size() < 1:
				manager.pause = true
				yield(get_tree().create_timer(0.6), "timeout")
				manager.pause = false
				players[-1].placeCounter()
			elif playersNumber == 1 and currentTurn == 1:
				manager.pause = true
				yield(get_tree().create_timer(0.6), "timeout")
				manager.pause = false
				players[-1].pawns[0].moveCounter()
			isEndGame()

func _unhandled_input(event):
	if event.is_action_pressed("click"):
		placePawns()
