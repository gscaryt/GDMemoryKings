extends Area2D

var Rank : String
var Suit : String
var Back : String
var gridPos : Vector2
var isRecruited : bool
var whoRecruited : String
var isRevealed : bool

func flip() -> void:
	# Hides or Reveals this Card.
	if isRevealed:
		get_node("Back").set_visible(true)
		isRevealed = false
	else:
		get_node("Back").set_visible(false)
		isRevealed = true

func escortCheck(gridDest) -> bool:
	# Evaluates if any escort movement condition is met.
	if (
		escortBishop(gridDest)
		or escortKnight(gridDest)
		or escortRook(gridDest)
		or escortQueen(gridDest)
	):
		print("Valid " + Rank + " escort.")
		return true
	return false

func escortBishop(gridDest) -> bool:
	# Checks if diagonal movement.
	if Rank == "BISHOP":
		if abs(gridDest[0] - gridPos[0]) == abs(gridDest[1] - gridPos[1]):
			return true
	return false

func escortRook(gridDest) -> bool:
	# Checks if orthogonal movement.
	if Rank == "ROOK":
		if gridDest[0] == gridPos[0] or gridDest[1] == gridPos[1]:
			return true
	return false

func escortKnight(gridDest) -> bool:
	# Checks if knight's ("L-shaped") movement.
	if Rank == "KNIGHT":
		if (
			(abs(gridDest[0] - gridPos[0]) == 2 
			and abs(gridDest[1] - gridPos[1]) == 1)
			or (abs(gridDest[0] - gridPos[0]) == 1 
			and abs(gridDest[1] - gridPos[1]) == 2)
		):
			return true
	return false

func escortQueen(gridDest) -> bool:
	# Checks if diagonal or orthogonal movement.
	if Rank == "QUEEN":
		if (
			abs(gridDest[0] - gridPos[0]) == abs(gridDest[1] - gridPos[1])
			or gridDest[0] == gridPos[0] or gridDest[1] == gridPos[1]
		):
			return true
	return false
