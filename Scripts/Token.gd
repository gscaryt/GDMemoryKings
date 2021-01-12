extends Area2D

onready var player : Node2D = get_parent()

onready var color : String = player.color
onready var sprite = load(
	"res://Sprites/Tokens/token_" + str(color.to_lower()) + ".png"
	)

var gridPos : Vector2

func _ready():
	get_node("Sprite").texture = sprite
