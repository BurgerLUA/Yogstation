/datum/hud/revenant
	ui_style = 'icons/mob/screen_gen.dmi'

/datum/hud/revenant/New(mob/owner)
	..()

	pull_icon = new /atom/movable/screen/pull(src)
	pull_icon.icon = ui_style
	pull_icon.update_icon()
	pull_icon.screen_loc = ui_living_pull
	static_inventory += pull_icon

	healths = new /atom/movable/screen/healths/revenant(src)
	infodisplay += healths
