/datum/hud/monkey/New(mob/living/carbon/monkey/owner)
	..()
	var/atom/movable/screen/using
	var/atom/movable/screen/inventory/inv_box

	action_intent = new /atom/movable/screen/act_intent(src)
	action_intent.icon = ui_style
	action_intent.icon_state = mymob.a_intent
	action_intent.screen_loc = ui_acti
	static_inventory += action_intent

	using = new /atom/movable/screen/mov_intent(src)
	using.icon = ui_style
	using.icon_state = (mymob.m_intent == MOVE_INTENT_RUN ? "running" : "walking")
	using.screen_loc = ui_movi
	static_inventory += using

	using = new /atom/movable/screen/language_menu(src)
	using.icon = ui_style
	static_inventory += using

	using = new /atom/movable/screen/drop(src)
	using.icon = ui_style
	using.screen_loc = ui_drop_throw
	static_inventory += using

	build_hand_slots()

	using = new /atom/movable/screen/swap_hand(src)
	using.icon = ui_style
	using.icon_state = "swap_1_m"	//extra wide!
	using.screen_loc = ui_swaphand_position(owner,1)
	static_inventory += using

	using = new /atom/movable/screen/swap_hand(src)
	using.icon = ui_style
	using.icon_state = "swap_2"
	using.screen_loc = ui_swaphand_position(owner,2)
	static_inventory += using

	inv_box = new /atom/movable/screen/inventory(src)
	inv_box.name = "mask"
	inv_box.icon = ui_style
	inv_box.icon_state = "mask"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_monkey_mask
	inv_box.slot_id = ITEM_SLOT_MASK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(src)
	inv_box.name = "neck"
	inv_box.icon = ui_style
	inv_box.icon_state = "neck"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_monkey_neck
	inv_box.slot_id = ITEM_SLOT_NECK
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(src)
	inv_box.name = "head"
	inv_box.icon = ui_style
	inv_box.icon_state = "head"
//	inv_box.icon_full = "template"
	inv_box.screen_loc = ui_monkey_head
	inv_box.slot_id = ITEM_SLOT_HEAD
	static_inventory += inv_box

	inv_box = new /atom/movable/screen/inventory(src)
	inv_box.name = "back"
	inv_box.icon = ui_style
	inv_box.icon_state = "back"
	inv_box.screen_loc = ui_monkey_back
	inv_box.slot_id = ITEM_SLOT_BACK
	static_inventory += inv_box

	throw_icon = new /atom/movable/screen/throw_catch(src)
	throw_icon.icon = ui_style
	throw_icon.screen_loc = ui_drop_throw
	hotkeybuttons += throw_icon

	healths = new /atom/movable/screen/healths(src)
	infodisplay += healths

	pull_icon = new /atom/movable/screen/pull(src)
	pull_icon.icon = ui_style
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_above_movement
	static_inventory += pull_icon

	zone_select = new /atom/movable/screen/zone_sel(src)
	zone_select.icon = ui_style
	zone_select.update_icon()
	static_inventory += zone_select

	mymob.client.screen = list()

	using = new /atom/movable/screen/resist(src)
	using.icon = ui_style
	using.screen_loc = ui_above_intent
	hotkeybuttons += using

	for(var/atom/movable/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv
			inv.update_icon()

/datum/hud/monkey/persistent_inventory_update()
	if(!mymob)
		return
	var/mob/living/carbon/monkey/M = mymob

	if(hud_shown)
		if(M.back)
			M.back.screen_loc = ui_monkey_back
			M.client.screen += M.back
		if(M.wear_mask)
			M.wear_mask.screen_loc = ui_monkey_mask
			M.client.screen += M.wear_mask
		if(M.wear_neck)
			M.wear_neck.screen_loc = ui_monkey_neck
			M.client.screen += M.wear_neck
		if(M.head)
			M.head.screen_loc = ui_monkey_head
			M.client.screen += M.head
	else
		if(M.back)
			M.back.screen_loc = null
		if(M.wear_mask)
			M.wear_mask.screen_loc = null
		if(M.head)
			M.head.screen_loc = null

	if(hud_version != HUD_STYLE_NOHUD)
		for(var/obj/item/I in M.held_items)
			I.screen_loc = ui_hand_position(M.get_held_index_of_item(I))
			M.client.screen += I
	else
		for(var/obj/item/I in M.held_items)
			I.screen_loc = null
			M.client.screen -= I
