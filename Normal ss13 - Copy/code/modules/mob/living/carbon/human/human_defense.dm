/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor/laserproof))
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			var/reflectchance = 40 - round(P.damage/3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(prob(reflectchance))
				visible_message("<span class='danger'>The [P.name] gets reflected by [src]'s [wear_suit.name]!</span>", \
								"<span class='userdanger'>The [P.name] gets reflected by [src]'s [wear_suit.name]!</span>")

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation

	if(check_shields(P.damage, "the [P.name]"))
		P.on_hit(src, 2)
		return 2
	return (..(P , def_zone))


/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isorgan(def_zone))
			return checkarmor(def_zone, type)
		var/datum/limb/affecting = get_organ(ran_zone(def_zone))
		return checkarmor(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/datum/limb/organ in organs)
		armorval += checkarmor(organ, type)
		organnum++
	return (armorval/max(organnum, 1))


/mob/living/carbon/human/proc/checkarmor(var/datum/limb/def_zone, var/type)
	if(!type)	return 0
	var/protection = 0
	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor[type]
	return protection


/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/attack_text = "the attack")
	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		var/obj/item/weapon/I = l_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("<span class='danger'>[src] blocks [attack_text] with [l_hand]!</span>", \
							"<span class='userdanger'>[src] blocks [attack_text] with [l_hand]!</span>")
			return 1
	if(r_hand && istype(r_hand, /obj/item/weapon))
		var/obj/item/weapon/I = r_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("<span class='danger'>[src] blocks [attack_text] with [r_hand]!</span>", \
							"<span class='userdanger'>[src] blocks [attack_text] with [r_hand]!</span>")
			return 1
	if(wear_suit && istype(wear_suit, /obj/item/))
		var/obj/item/I = wear_suit
		if(I.IsShield() && (prob(35)))
			visible_message("<span class='danger'>The reactive teleport system flings [src] clear of [attack_text]!</span>", \
							"<span class='userdanger'>The reactive teleport system flings [src] clear of [attack_text]!</span>")
			var/list/turfs = new/list()
			for(var/turf/T in orange(6))
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-6 || T.x<6)	continue
				if(T.y>world.maxy-6 || T.y<6)	continue
				turfs += T
			if(!turfs.len) turfs += pick(/turf in orange(6))
			var/turf/picked = pick(turfs)
			if(!isturf(picked)) return
			src.loc = picked
			return 1
	return 0

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	..()


/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I || !user)	return 0

	var/datum/limb/affecting = get_organ(ran_zone(user.zone_sel.selecting))

	var/hit_area = parse_zone(affecting.name)

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(I.attack_verb.len)
		visible_message("<span class='danger'>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I] by [user]!</span>", \
						"<span class='userdanger'>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I] by [user]!</span>")
	else
		visible_message("<span class='danger'>[src] has been attacked in the [hit_area] with [I] by [user]!</span>", \
						"<span class='userdanger'>[src] has been attacked in the [hit_area] with [I] by [user]!</span>")

	var/armor = run_armor_check(affecting, "melee", "<span class='warning'>Your armour has protected your [hit_area].</span>", "<span class='warning'>Your armour has softened hit to your [hit_area].</span>")
	if(armor >= 2)	return 0
	if(!I.force)	return 0

	apply_damage(I.force, I.damtype, affecting, armor , I)

	var/bloody = 0
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (I.force * 2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
		if(prob(I.force * 2))	//blood spatter!
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) > 1)	//people with TK won't get smeared with blood
					if(H.wear_suit)
						H.wear_suit.add_blood(src)
						H.update_inv_wear_suit(0)	//updates mob overlays to show the new blood (no refresh)
					else if(H.w_uniform)
						H.w_uniform.add_blood(src)
						H.update_inv_w_uniform(0)	//updates mob overlays to show the new blood (no refresh)
					if (H.gloves)
						var/obj/item/clothing/gloves/G = H.gloves
						G.add_blood(H)
						G.transfer_blood = 2
						G.bloody_hands_mob = H
					else
						H.add_blood(H)
						H.bloody_hands = 2
						H.bloody_hands_mob = H
					H.update_inv_gloves()	//updates on-mob overlays for bloody hands and/or bloody gloves

		switch(hit_area)
			if("head")	//Harder to score a stun but if you do it lasts a bit longer
				if(prob(I.force))
					visible_message("<span class='danger'>[src] has been knocked unconscious!</span>", \
									"<span class='userdanger'>[src] has been knocked unconscious!</span>")
					apply_effect(20, PARALYZE, armor)
					if(src != user && I.damtype == BRUTE)
						ticker.mode.remove_revolutionary(mind)

				if(bloody)	//Apply blood
					if(wear_mask)
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)

			if("chest")	//Easier to score a stun but lasts less time
				if(prob(I.force + 10))
					visible_message("<span class='danger'>[src] has been knocked down!</span>", \
									"<span class='userdanger'>[src] has been knocked down!</span>")
					apply_effect(5, WEAKEN, armor)

				if(bloody)
					if(wear_suit)
						wear_suit.add_blood(src)
						update_inv_wear_suit(0)
					if(w_uniform)
						w_uniform.add_blood(src)
						update_inv_w_uniform(0)

		if(I.force > 10 || I.force >= 5 && prob(33))
			forcesay(hit_appends)