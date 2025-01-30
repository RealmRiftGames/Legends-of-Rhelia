extends Node2D

const CARD_SCENE_PATH = "res://scenes/Card.tscn"
const CARD_DRAW_SPEED = .35
const STARTING_HAND_SIZE = 5

var player_deck = ["Blaine Orynthar", "Clan Noble", "Clan Noble", 
"Clan Noble", "Field Engineer", "Field Engineer", "Field Engineer", "Forest Strider",
"Forest Strider", "Forest Strider", "Gavric Thornlan", "Glade Marshal",
"Glade Marshal", "Glade Marshal", "Highland Soldier", "Highland Soldier", 
"Highland Soldier", "Iarius the Blessed", "Kyrna Rynnard", "Lochwyn Brother", 
"Lochwyn Brother", "Lochwyn Brother", "Spearwall Defender", "Spearwall Defender",
"Spearwall Defender", "Tavor Cairnmor"]
var card_database_reference
var drawn_card_this_turn = false

func _ready() -> void:
	player_deck.shuffle()
	await get_tree().create_timer(.5).timeout
	$RichTextLabel.text = str(player_deck.size())
	card_database_reference = preload("res://scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()
		drawn_card_this_turn = false
	drawn_card_this_turn = true

func draw_card():
	if drawn_card_this_turn or player_deck.size() == 0:
		return 
	
	drawn_card_this_turn = true
	
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$RichTextLabel.visible = false

	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://AllCards/HighlanderCards/" + card_drawn_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.get_node("Strength").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.card_type = card_database_reference.CARDS[card_drawn_name][1]
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("card_flip")

func reset_draw():
	drawn_card_this_turn = false
