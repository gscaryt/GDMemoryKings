extends Node2D

onready var board : = get_parent()
onready var game : = board.get_parent()
onready var manager : = game.get_parent()
onready var scoreBoard : = game.get_node("ScoreBoard")
onready var SFX : = game.get_parent().get_node("SFX")

var color : String
var orderNumber : int

onready var score : int = 0
onready var _token : = preload("res://Scenes/Token.tscn")
onready var _pawn : = preload("res://Scenes/Pawn.tscn")
onready var pawns : Array = []

onready var isTurn : bool

onready var isCounter : bool

var hover = false

func _displayPawn(gridPos, pawnIndex):
	var posX : int
	var posY : int
	
	if isCounter:
		posX = 110*(gridPos[0])-38
		posY = 110*(gridPos[1])-38
		return Vector2(posX, posY)
		
	else:
		posX = 110*(gridPos[0])-38+pawnIndex*25
		posY = 110*(gridPos[1])+38-orderNumber*25
		return Vector2(posX, posY)

func placeCheck(gridPos) -> bool:
	if game.playersNumber == 1:
		if board.getCard(gridPos).Back == board.getCard(Vector2(0,0)).Back:
			return true
		else:
			return false
	if game.playersNumber > 1:
		if board.getCard(gridPos).Back == "WHITE":
			return true
		else:
			return false
	return false

func placeCounter() -> void:
	if isCounter:
		pawns.append(_pawn.instance())
		add_child(pawns[-1])
		pawns[-1].gridPos = Vector2(0,0)
		SFX.get_node("PutDown").play()
		pawns[-1].position = (
			_displayPawn(Vector2(0,0), pawns.find(pawns[-1]))
			)
		scoreBoard.showScores[-1].get_node("Pawns").visible = false
		scoreBoard.showScores[-1].get_node("Score").visible = true
		manager.counterSet = true

func placePawn() -> bool:
	if not isCounter and manager.counterSet:
		if typeof(board.getClick()) == 5: # typeof() == 5 is Vector2
			var gridClick = board.getClick()
			if placeCheck(gridClick):
				pawns.append(_pawn.instance())
				add_child(pawns[-1])
				pawns[-1].gridPos = gridClick
				SFX.get_node("PutDown").play()
				pawns[-1].position = (
					_displayPawn(gridClick, pawns.find(pawns[-1]))
					)
				if pawns.size() == 1:
					scoreBoard.showScores[orderNumber].get_node("Pawns").get_node("1").visible = false
				else:
					scoreBoard.showScores[orderNumber].get_node("Pawns").visible = false
					scoreBoard.showScores[orderNumber].get_node("Score").visible = true
				return true
	return false

func placeToken(gridPos) -> void:
	var token = _token.instance()
	add_child(token)
	token.gridPos = gridPos
	var posX : int
	var posY : int
	posX = 110*(gridPos[0])+35
	posY = 110*(gridPos[1])-35
	token.position = Vector2(posX, posY)

func recruitSFX(rank):
	if not isCounter:
		if rank == "BISHOP":
			SFX.get_node("Bishop").play()
		elif rank == "KNIGHT":
			SFX.get_node("Knight").play()
		elif rank == "ROOK":
			SFX.get_node("Rook").play()
	elif isCounter:
		SFX.get_node("Counter").play()

func recruitCheck() -> bool:
	if not isCounter:
		var card1 = board.getCard(pawns[0].gridPos)
		var card2 = board.getCard(pawns[1].gridPos)
		if not card1.isRecruited and not card2.isRecruited:
			if card1.gridPos != card2.gridPos:
				if card1.Rank == card2.Rank and card1.Suit == card2.Suit:
					card1.isRecruited = true
					card2.isRecruited = true
					card1.whoRecruited = color
					card2.whoRecruited = color
					recruitSFX(card1.Rank)
					placeToken(card1.gridPos)
					placeToken(card2.gridPos)
					score += 1
					scoreBoard.showScores[orderNumber].get_node("Score").text = String(score)
					print("Player " + color + ": " + str(score) + " points")
					return true
	return false

func counterRecruitCheck() -> bool:
	if isCounter:
		var card1 = board.getCard(pawns[0].gridPos)
		for i in range(2):
			var card2 = board.getCard(game.players[0].pawns[i].gridPos)
			if not card1.isRecruited and not card2.isRecruited:
				if card1.gridPos != card2.gridPos:
					if card1.Rank == card2.Rank and card1.Suit == card2.Suit:
						card1.isRecruited = true
						card2.isRecruited = true
						card1.whoRecruited = color
						card2.whoRecruited = color
						recruitSFX(null)
						placeToken(card1.gridPos)
						placeToken(card2.gridPos)
						score += 1
						scoreBoard.showScores[orderNumber].get_node("Score").text = String(score)
						print("Player " + color + ": " + str(score) + " points")
						return true
	return false
