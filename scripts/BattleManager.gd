extends Node

const SMALL_CARD_SCALE = 0.6
const CARD_MOVE_SPEED = 0.2

var battle_timer
var empty_unit_card_slots = []
var card_type

func _ready() -> void:
	battle_timer = $"../BattleTimer"
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot1")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot2")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot3")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot4")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot5")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot6")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot7")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot8")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot9")
	empty_unit_card_slots.append($"../Card Slots/OpponentCardSlot10")

func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	$"../EndTurnButton".disabled = true
	$"../EndTurnButton".visible = false
	
	battle_timer.start()
	await battle_timer.timeout
	
	if $"../OpponentDeck".opponent_deck.size() != 0:
		$"../OpponentDeck".draw_card()
		battle_timer.start()
		await battle_timer.timeout
	
	if empty_unit_card_slots.size() == 0:
		end_opponent_turn()
		return
	
	await try_play_card_with_highest_str()
	end_opponent_turn()

func try_play_card_with_highest_str():
	var opponent_hand = $"../OpponentHand".opponent_hand
	if opponent_hand.size() == 0:
		end_opponent_turn()
		return
	
	var random_empty_unit_card_slot = empty_unit_card_slots.pick_random()
	empty_unit_card_slots.erase(random_empty_unit_card_slot)
	
	# Find card with highest strength
	var most_important_card = opponent_hand[0]
	for card in opponent_hand:
		if card.strength > most_important_card.strength:
			most_important_card = card
	
	# Animate card movement and scale
	var tween = get_tree().create_tween()
	tween.tween_property(most_important_card, "position", random_empty_unit_card_slot.position, CARD_MOVE_SPEED)
	tween.tween_property(most_important_card, "scale", Vector2(SMALL_CARD_SCALE, SMALL_CARD_SCALE), CARD_MOVE_SPEED)
	most_important_card.get_node("AnimationPlayer").play("card_flip")
	
	$"../OpponentHand".remove_card_from_hand(most_important_card)
	
	battle_timer.start()
	await battle_timer.timeout

func end_opponent_turn():
	$"../Deck".reset_draw()
	$"../CardManager".reset_played_unit()
	$"../EndTurnButton".disabled = false
	$"../EndTurnButton".visible = true
