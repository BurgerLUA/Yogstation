/turf
	var/dynamic_lighting = TRUE
	luminosity           = 1

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/datum/lighting_object/lighting_object // Our lighting object.

	///Lighting Corner datums.
	var/tmp/datum/lighting_corner/lighting_corner_NE
	var/tmp/datum/lighting_corner/lighting_corner_SE
	var/tmp/datum/lighting_corner/lighting_corner_SW
	var/tmp/datum/lighting_corner/lighting_corner_NW

	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/dynamic_lumcount = 0

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	lighting_corner_NE?.vis_update()
	lighting_corner_SE?.vis_update()
	lighting_corner_SW?.vis_update()
	lighting_corner_NW?.vis_update()

/turf/proc/lighting_clear_overlay()
	if (lighting_object)
		qdel(lighting_object, force=TRUE)

// Builds a lighting object for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if (lighting_object)
		qdel(lighting_object, force=TRUE) //Shitty fix for lighting objects persisting after death

	var/area/our_area = loc
	if (!IS_DYNAMIC_LIGHTING(our_area) && !light_sources)
		return

	new/datum/lighting_object(src)

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if (!lighting_object)
		return 1

	var/totallums = 0
	var/datum/lighting_corner/L
	L = lighting_corner_NE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
	L = lighting_corner_SE
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
	L = lighting_corner_SW
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g
	L = lighting_corner_NW
	if (L)
		totallums += L.lum_r + L.lum_b + L.lum_g


	totallums /= 12 // 4 corners, each with 3 channels, get the average.

	totallums = (totallums - minlum) / (maxlum - minlum)

	totallums += dynamic_lumcount

	return CLAMP01(totallums)

// Returns a boolean whether the turf is on soft lighting.
// Soft lighting being the threshold at which point the overlay considers
// itself as too dark to allow sight and see_in_dark becomes useful.
// So basically if this returns true the tile is unlit black.
/turf/proc/is_softly_lit()
	if (!lighting_object)
		return FALSE

	return !luminosity

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = opacity
	if (!has_opaque_atom)
		for (var/atom/A in src.contents) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
			if (A.opacity)
				has_opaque_atom = TRUE
				break

/turf/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	if (Obj && Obj.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/change_area(area/old_area, area/new_area)
	if(SSlighting.initialized)
		if (new_area.dynamic_lighting != old_area.dynamic_lighting)
			if (new_area.dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/generate_missing_corners()
	if (!lighting_corner_NE)
		lighting_corner_NE = new/datum/lighting_corner(src, NORTH|EAST)

	if (!lighting_corner_SE)
		lighting_corner_SE = new/datum/lighting_corner(src, SOUTH|EAST)

	if (!lighting_corner_SW)
		lighting_corner_SW = new/datum/lighting_corner(src, SOUTH|WEST)

	if (!lighting_corner_NW)
		lighting_corner_NW = new/datum/lighting_corner(src, NORTH|WEST)

	lighting_corners_initialised = TRUE

/turf/proc/get_affecting_lights()
	var/list/affecting = list()

	if (!lighting_object)
		return affecting

	var/datum/lighting_corner/L
	L = lighting_corner_NE
	if (L)
		affecting += L.affecting
	L = lighting_corner_SE
	if (L)
		affecting += L.affecting
	L = lighting_corner_SW
	if (L)
		affecting += L.affecting
	L = lighting_corner_NW
	if (L)
		affecting += L.affecting

	return uniqueList(affecting)
