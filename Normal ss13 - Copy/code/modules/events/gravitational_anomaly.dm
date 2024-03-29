/datum/event_control/gravitational_anomaly
	name = "Gravitational Anomaly"
	typepath = /datum/event/gravitational_anomaly
	max_occurrences = 5
	weight = 2

/datum/event/gravitational_anomaly
	startWhen = 10

	var/obj/effect/bhole/blackhole

/datum/event/gravitational_anomaly/announce()
	command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
	for(var/mob/M in player_list)
		if(!istype(M,/mob/new_player))
			M << sound('sound/AI/granomalies.ogg')

/datum/event/gravitational_anomaly/setup()
	endWhen = rand(50, 200)

/datum/event/gravitational_anomaly/start()
	var/turf/T = pick(blobstart)
	blackhole = new /obj/effect/bhole( T.loc, 30 )

/datum/event/gravitational_anomaly/end()
	del(blackhole)


/obj/effect/bhole
	name = "black hole"
	icon = 'icons/obj/objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole3"
	opacity = 1
	unacidable = 1
	density = 0
	anchored = 1

/obj/effect/bhole/New()
	spawn(4)
		controller()

/obj/effect/bhole/proc/controller()
	while(src)

		if(!isturf(loc))
			del(src)
			return

		//DESTROYING STUFF AT THE EPICENTER
		for(var/mob/living/M in orange(1,src))
			del(M)
		for(var/obj/O in orange(1,src))
			del(O)
		for(var/turf/simulated/ST in orange(1,src))
			ST.ChangeTurf(/turf/space)

		sleep(6)
		grav(10, 4, 10, 0 )
		sleep(6)
		grav( 8, 4, 10, 0 )
		sleep(6)
		grav( 9, 4, 10, 0 )
		sleep(6)
		grav( 7, 3, 40, 1 )
		sleep(6)
		grav( 5, 3, 40, 1 )
		sleep(6)
		grav( 6, 3, 40, 1 )
		sleep(6)
		grav( 4, 2, 50, 6 )
		sleep(6)
		grav( 3, 2, 50, 6 )
		sleep(6)
		grav( 2, 2, 75,25 )
		sleep(6)

		//MOVEMENT
		if( prob(50) )
			src.anchored = 0
			step(src,pick(alldirs))
			src.anchored = 1

/obj/effect/bhole/proc/grav(var/r, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	if(!isturf(loc))	//blackhole cannot be contained inside anything. Weird stuff might happen
		del(src)
		return
	for(var/t = -r, t < r, t++)
		affect_coord(x+t, y-r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-t, y+r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x+r, y+t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x-r, y-t, ex_act_force, pull_chance, turf_removal_chance)
	return

/obj/effect/bhole/proc/affect_coord(var/x, var/y, var/ex_act_force, var/pull_chance, var/turf_removal_chance)
	//Get turf at coordinate
	var/turf/T = locate(x, y, z)
	if(isnull(T))	return

	//Pulling and/or ex_act-ing movable atoms in that turf
	if( prob(pull_chance) )
		for(var/obj/O in T.contents)
			if(O.anchored)
				O.ex_act(ex_act_force)
			else
				step_towards(O,src)
		for(var/mob/living/M in T.contents)
			step_towards(M,src)

	//Destroying the turf
	if( T && istype(T,/turf/simulated) && prob(turf_removal_chance) )
		var/turf/simulated/ST = T
		ST.ChangeTurf(/turf/space)
	return