extends TileMap

onready var game : Node2D = get_parent()
onready var manager : = game.get_parent()

onready var _card : = preload("res://Scenes/Card.tscn")

var Ranks : = ["BISHOP", "KNIGHT", "ROOK"]
var Suits : = ["RED", "BLUE", "GREEN", "YELLOW", "PURPLE", "BROWN"]
var Backs : = ["BLACK", "WHITE"]
var deck : Array

var popTime : float = 0.07
var cardSize : int = 110

func genDeck() -> Array:
	# Generates Cards and creates a deck array with the Card Nodes.
	var cols : int = game.gridSize[0]
	var rows : int = game.gridSize[1]
	var _num_of_colors : int = (
		((rows*cols)-1+((rows*cols)+1)%2)/(Backs.size()*Ranks.size())
	)
	var _deck : = []
	
	# Adds the Special Cards (ie. Queen) to the deck first.
	var _queen := _card.instance()
	_queen.Back = "BLACK"
	_queen.Rank = "QUEEN"
	_queen.Suit = ""
	_queen.get_node("Face").texture = load("res://Sprites/Cards/_queen.png")
	_queen.get_node("Back").texture = load("res://Sprites/Cards/black_back.png")
	_deck.append(_queen)
	
	# Then adds the rest of the cards to the deck.
	for back in range(Backs.size()):
		for rank in range(Ranks.size()):
			for suit in range(_num_of_colors):
				var _new_card := _card.instance()
				_new_card.Back = Backs[back]
				_new_card.Rank = Ranks[rank]
				_new_card.Suit = Suits[suit]
				_new_card.get_node("Face").texture = (
					load("res://Sprites/Cards/" + Suits[suit].to_lower()
					+ "_" + Ranks[rank].to_lower() + ".png")
				)
				_new_card.get_node("Back").texture = (
					load("res://Sprites/Cards/" + Backs[back].to_lower()
					+ "_back.png")
				)
				_deck.append(_new_card)
				randomize()
				_deck.shuffle()
	return _deck

func buildBoard() -> void:
	# Positions and Displays cards on the Board.
	var cols : int = game.gridSize[0]
	var rows : int = game.gridSize[1]
	position += (
		Vector2(cardSize*(1-0.5*(cols%5)), cardSize*(1-0.5*(rows%5)))
	)
	
	# Positions cards on the Board (both gridPos and position (i.e. on Screen)).
	for j in range(rows):
		for i in range(cols):
			var card = deck[cols*j+i]
			card.gridPos = Vector2(i, j)
			add_child(card)
			card.position = Vector2(cardSize*i,cardSize*j)
	
	# Randomize the order the cards will Pop on screen.
	var numArray : Array = []
	for n in range(cols*rows):
		numArray.append(n)
	randomize()
	numArray.shuffle()
	for n in numArray:
		deck[n].get_node('Animation').play('Pop')
		deck[n].get_node("Blop").play()
		yield(get_tree().create_timer(popTime), "timeout")
	manager.boardReady = true

func getCard(gridPos):
	# Converts gridPos to relative position in the Deck.
	var cols : int = game.gridSize[0]
	return deck[cols*gridPos[1]+gridPos[0]]

func getClick():
	var cols : int = game.gridSize[0]
	var rows : int = game.gridSize[1]
	var gridClick = world_to_map(
				get_local_mouse_position()
				+ Vector2(cardSize/2, cardSize/2)
			)
	if -1 < gridClick[0] and gridClick[0] < cols:
		if -1 < gridClick[1] and gridClick[1] < rows:
			return gridClick
	print("Invalid Click")
	return false

func displayCards() -> void:
	if manager.allPawnsSet:
		for card in deck:
			if card.isRecruited:
				card.get_node("Back").visible = false
				card.isRevealed = true
				continue
			else:
				for player in get_parent().players:
					for pawn in player.pawns:
						if pawn.gridPos == card.gridPos:
							card.get_node("Back").visible = false
							card.isRevealed = true
							break
						else:
							card.get_node("Back").visible = true
							card.isRevealed = false
					if card.isRevealed:
						break

