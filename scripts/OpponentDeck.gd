extends Node2D

const CARD_SCENE_PATH = "res://scenes/OpponentCard.tscn"
const CARD_DRAW_SPEED = .35
const STARTING_HAND_SIZE = 5

var opponent_deck = ["Alastor Dorath", "Alianna Maridin", "Anluan Las'ner", 
"Ashblood Blade", "Ashblood Blade", "Ashblood Blade", "Ashen Guard", 
"Ashen Guard", "Ashen Guard", "Blood Zerker", "Blood Zerker",  
"Blood Zerker", "Darragh Stormfel", "Duskscourge Slayer",  
"Duskscourge Slayer", "Duskscourge Slayer", "Ember Warden", 
"Ember Warden", "Ember Warden", "Korrath Anwair", "Lifebinder",
"Lifebinder", "Lifebinder", "Malcanth Drummyn", "Torch Bearer", 
"Torch Bearer", "Torch Bearer", "Torran Glydel"]
var card_database_reference

func _ready() -> void:
	opponent_deck.shuffle()
	await get_tree().create_timer(.5).timeout
	$RichTextLabel.text = str(opponent_deck.size())
	card_database_reference = preload("res://scripts/CardDatabase.gd")
	for i in range(STARTING_HAND_SIZE):
		draw_card()

func draw_card():
	if opponent_deck.size() == 0:
		return
		
	var card_drawn_name = opponent_deck[0]
	opponent_deck.erase(card_drawn_name)
	
	if opponent_deck.size() == 0:
		$Sprite2D.visible = false
		$RichTextLabel.visible = false

	$RichTextLabel.text = str(opponent_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	var card_image_path = str("res://AllCards/AshenbornCards/" + card_drawn_name + ".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	new_card.strength = card_database_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Strength").text = str(new_card.strength)
	new_card.card_type = card_database_reference.CARDS[card_drawn_name][1]
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../OpponentHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	new_card.get_node("AnimationPlayer").play("opponent_draw")
