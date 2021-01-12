extends Area2D

onready var player : Node2D = get_parent()
onready var board : Node2D = player.get_parent()
onready var game : Node2D = board.get_parent()
onready var SFX : = game.get_parent().get_node("SFX")

onready var color : String = player.color
onready var sprite = load(
	"res://Sprites/Pawns/pawn_" + str(color.to_lower()) + ".png"
	)

onready var isSelected : bool

var gridPos : Vector2

func moveCheck(gridDest) -> bool:
	if not gridPos == gridDest:
		if pawnMoveCheck(gridDest):
			return true
		elif board.getCard(gridPos).escortCheck(gridDest):
			if not board.getCard(gridPos).isRecruited:
				return true
			if board.getCard(gridPos).whoRecruited == color:
				return true
	return false
	
func pawnMoveCheck(gridDest) -> bool:
	# A pawn can ALWAYS move 1 adjacent space.
	if (
		abs(gridDest[0] - gridPos[0]) == 1 and gridDest[1] == gridPos[1]
		or abs(gridDest[1] - gridPos[1]) == 1 and gridDest[0] == gridPos[0]
	):
		print("Valid PAWN move.")
		return true
	return false

func select(event) -> void:
	# If no pawn is selected, selects when clicking on a pawn. 
	# If a pawn is selected, yields waiting for a movement.
	if player.isTurn:
		if event is InputEventMouseButton:
			if event.is_pressed():
				SFX.get_node("PickUp").play()
				isSelected = true
				get_node("Shade").visible = true
			else:
				yield()
				isSelected = false
				get_node("Shade").visible = false

func move() -> void:
	# Coroutine to move a selected pawn.
	var gridClick = board.getClick()
	if typeof(gridClick) == 5: # typeof() == 5 is Vector2
		if moveCheck(gridClick):
			position = (
				player._displayPawn(gridClick, player.pawns.find(self))
				)
			gridPos = gridClick
			SFX.get_node("PutDown").play()
			isSelected = false
			get_node("Shade").visible = false
			if player.recruitCheck():
				return # When finding a pair, earn an extra turn.
			if game.players[-1].counterRecruitCheck():
				game.players[-1].pawns[0].moveCounter() # Extra Counter Move
			else:
				game.changeTurn()
		else:
			isSelected = false
			get_node("Shade").visible = false
	else:
		isSelected = false
		get_node("Shade").visible = false

func moveCounter() -> void:
	if player.isCounter:
		if gridPos[0] < game.gridSize[0]-1 and int(gridPos[1]) % 2 == 0:
			gridPos[0] += 1
		elif gridPos[0] > 0 and int(gridPos[1]) % 2 != 0:
			gridPos[0] -= 1
		elif gridPos[1] < game.gridSize[1]-1:
			gridPos[1] += 1
		SFX.get_node("PutDown").play()
		position = player._displayPawn(gridPos, player.pawns.find(self))
		if player.counterRecruitCheck():
			yield(get_tree().create_timer(1), "timeout")
		else:
			game.changeTurn()

func _ready():
	get_node("Sprite").texture = sprite

func _on_Pawn_mouse_entered():
	player.hover = true

func _on_Pawn_mouse_exited():
	player.hover = false

func _on_Pawn_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		select(event)

func _unhandled_input(event):
	if event.is_action_pressed("click") and isSelected:
		if not player.hover:
			move()
		else:
			isSelected = false
			get_node("Shade").visible = false
