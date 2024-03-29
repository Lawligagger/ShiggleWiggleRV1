//DEBUGGING
#define DEBUG					//Enables byond profiling and full runtime logs
//#define dellogging			//Enables logging of forced del() calls (used for debugging)
//#define TESTING				//Enables in-depth debug messages to runtime log (used for debugging)
								//By using the testing("message") proc you can create debug-feedback for people with this
								//uncommented, but not visible in the release version)



//SYSTEM TOGGLES - these allow you to compile the game without some of the laggier systems if your server cannot cope with demand
/* Not yet coded
#define USE_DYNAMIC_GRAVITY		//Enables the dynamic gravity system
#define USE_DYNAMIC_LIGHTING	//Enables the dynamic lighting system
#define USE_DYNAMIC_ATMOS		//Enables the dynamic atmos system
*/



//ADMIN STUFF
#define ROUNDSTART_LOGOUT_REPORT_TIME	6000 //Amount of time (in deciseconds) after the rounds starts, that the player disconnect report is issued.

#define SPAM_TRIGGER_WARNING	5	//Number of identical messages required before the spam-prevention will warn you to stfu
#define SPAM_TRIGGER_AUTOMUTE	10	//Number of identical messages required before the spam-prevention will automute you
//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN			1024
#define MAX_NAME_LEN			26
#define MAX_BROADCAST_LEN		512



//MINOR TWEAKS/MISC
#define AGE_MIN				17	//youngest a character can be
#define AGE_MAX				85	//oldest a character can be
#define SHOES_SLOWDOWN		-1	//How much shoes slow you down by default. Negative values speed you up
#define HUMAN_STRIP_DELAY	40	//time taken (in deciseconds) to strip somebody
#define DOOR_CRUSH_DAMAGE	10	//the amount of damage that airlocks deal when they crush you

#define	HUNGER_FACTOR		0.1	//factor at which mob nutrition decreases
#define	REAGENTS_METABOLISM 0.4	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

#define MAX_STACK_AMOUNT_METAL	50
#define MAX_STACK_AMOUNT_GLASS	50
#define MAX_STACK_AMOUNT_RODS	60

#define AI_CAMERA_LUMINOSITY	5

#define TRANSITIONEDGE			7 //Distance from edge to move to another z-level

#define shuttle_time_in_station	1800 // 1800 = 3 minutes in the station
#define shuttle_time_to_arrive	6000 // 6000 = 10 minutes to arrive



//stuff you should probably leave well alone!
//ATMOS
#define CELL_VOLUME							2500	//liters in a cell
#define BREATH_VOLUME						0.5		//liters in a normal breath
#define BREATH_PERCENTAGE					(BREATH_VOLUME/CELL_VOLUME)					//Amount of air to take a from a tile
#define HUMAN_NEEDED_OXYGEN					(MOLES_CELLSTANDARD*BREATH_PERCENTAGE*0.16)	//Amount of air needed before pass out/suffocation commences
#define NORMPIPERATE						30		//pipe-insulation rate divisor
#define HEATPIPERATE						8		//heat-exch pipe insulation
#define FLOWFRAC							0.99	//fraction of gas transfered per process
#define TANK_LEAK_PRESSURE					(30.*ONE_ATMOSPHERE)	//Tank starts leaking
#define TANK_RUPTURE_PRESSURE				(40.*ONE_ATMOSPHERE)	//Tank spills all contents into atmosphere
#define TANK_FRAGMENT_PRESSURE				(50.*ONE_ATMOSPHERE)	//Boom 3x3 base explosion
#define TANK_FRAGMENT_SCALE	    			(10.*ONE_ATMOSPHERE)	//+1 for each SCALE kPa aboe threshold
#define MINIMUM_AIR_RATIO_TO_SUSPEND		0.05	//Minimum ratio of air that must move to/from a tile to suspend group processing
#define MINIMUM_AIR_TO_SUSPEND				(MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND)	//Minimum amount of air that has to move before a group processing can be suspended
#define MINIMUM_MOLES_DELTA_TO_MOVE			(MOLES_CELLSTANDARD*MINIMUM_AIR_RATIO_TO_SUSPEND) //Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE			(T20C+100)			//or this (or both, obviously)
#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND		0.012
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND		4		//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER		0.5		//Minimum temperature difference before the gas temperatures are just set to be equal
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		T20C+10
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	T20C+200
#define FLOOR_HEAT_TRANSFER_COEFFICIENT		0.4
#define WALL_HEAT_TRANSFER_COEFFICIENT		0.0
#define DOOR_HEAT_TRANSFER_COEFFICIENT		0.0
#define SPACE_HEAT_TRANSFER_COEFFICIENT		0.2		//a hack to partly simulate radiative heat
#define OPEN_HEAT_TRANSFER_COEFFICIENT		0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT	0.1		//a hack for now
	//Must be between 0 and 1. Values closer to 1 equalize temperature faster
	//Should not exceed 0.4 else strange heat flow occur
#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD	150+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST	100+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE			0.85
#define FIRE_CARBON_ENERGY_RELEASED			500000	//Amount of heat released per mole of burnt carbon into the tile
#define FIRE_PLASMA_ENERGY_RELEASED			3000000	//Amount of heat released per mole of burnt plasma into the tile
#define FIRE_GROWTH_RATE					40000	//For small fires
#define CARBON_LIFEFORM_FIRE_RESISTANCE 	200+T0C	//Resistance to fire damage
#define CARBON_LIFEFORM_FIRE_DAMAGE			4		//Fire damage
	//Plasma fire properties
#define PLASMA_MINIMUM_BURN_TEMPERATURE		100+T0C
#define PLASMA_UPPER_TEMPERATURE			1370+T0C
#define PLASMA_MINIMUM_OXYGEN_NEEDED		2
#define PLASMA_MINIMUM_OXYGEN_PLASMA_RATIO	30
#define PLASMA_OXYGEN_FULLBURN				10
#define MIN_PLASMA_DAMAGE					1
#define MAX_PLASMA_DAMAGE					10
#define MOLES_PLASMA_VISIBLE				0.7		//Moles in a standard cell after which plasma is visible

// Pressure limits.
#define HAZARD_HIGH_PRESSURE				550		//This determins at what pressure the ultra-high pressure red icon is displayed. (This one is set as a constant)
#define WARNING_HIGH_PRESSURE				325		//This determins when the orange pressure icon is displayed (it is 0.7 * HAZARD_HIGH_PRESSURE)
#define WARNING_LOW_PRESSURE				50		//This is when the gray low pressure icon is displayed. (it is 2.5 * HAZARD_LOW_PRESSURE)
#define HAZARD_LOW_PRESSURE					20		//This is when the black ultra-low pressure icon is displayed. (This one is set as a constant)

#define TEMPERATURE_DAMAGE_COEFFICIENT		1.5		//This is used in handle_temperature_damage() for humans, and in reagents that affect body temperature. Temperature damage is multiplied by this amount.
#define BODYTEMP_AUTORECOVERY_DIVISOR		12		//This is the divisor which handles how much of the temperature difference between the current body temperature and 310.15K (optimal temperature) humans auto-regenerate each tick. The higher the number, the slower the recovery. This is applied each tick, so long as the mob is alive.
#define BODYTEMP_AUTORECOVERY_MINIMUM		10		//Minimum amount of kelvin moved toward 310.15K per tick. So long as abs(310.15 - bodytemp) is more than 50.
#define BODYTEMP_COLD_DIVISOR				6		//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is lower than their body temperature. Make it lower to lose bodytemp faster.
#define BODYTEMP_HEAT_DIVISOR				6		//Similar to the BODYTEMP_AUTORECOVERY_DIVISOR, but this is the divisor which is applied at the stage that follows autorecovery. This is the divisor which comes into play when the human's loc temperature is higher than their body temperature. Make it lower to gain bodytemp faster.
#define BODYTEMP_COOLING_MAX				30		//The maximum number of degrees that your body can cool in 1 tick, when in a cold area.
#define BODYTEMP_HEATING_MAX				30		//The maximum number of degrees that your body can heat up in 1 tick, when in a hot area.

#define BODYTEMP_HEAT_DAMAGE_LIMIT			360.15 // The limit the human body can take before it starts taking damage from heat.
#define BODYTEMP_COLD_DAMAGE_LIMIT			260.15 // The limit the human body can take before it starts taking damage from coldness.

#define SPACE_HELMET_MIN_COLD_PROTECITON_TEMPERATURE	2.0		//what min_cold_protection_temperature is set to for space-helmet quality headwear. MUST NOT BE 0.
#define SPACE_SUIT_MIN_COLD_PROTECITON_TEMPERATURE		2.0		//what min_cold_protection_temperature is set to for space-suit quality jumpsuits or suits. MUST NOT BE 0.
#define FIRESUIT_MAX_HEAT_PROTECITON_TEMPERATURE		30000	//what max_heat_protection_temperature is set to for firesuit quality headwear. MUST NOT BE 0.
#define FIRE_HELMET_MAX_HEAT_PROTECITON_TEMPERATURE		30000	//for fire helmet quality items (red and white hardhats)
#define HELMET_MIN_COLD_PROTECITON_TEMPERATURE			160		//For normal helmets
#define HELMET_MAX_HEAT_PROTECITON_TEMPERATURE			600		//For normal helmets
#define ARMOR_MIN_COLD_PROTECITON_TEMPERATURE			160		//For armor
#define ARMOR_MAX_HEAT_PROTECITON_TEMPERATURE			600		//For armor

#define GLOVES_MIN_COLD_PROTECITON_TEMPERATURE			2.0		//For some gloves (black and)
#define GLOVES_MAX_HEAT_PROTECITON_TEMPERATURE			1500	//For some gloves
#define SHOE_MIN_COLD_PROTECITON_TEMPERATURE			2.0		//For gloves
#define SHOE_MAX_HEAT_PROTECITON_TEMPERATURE			1500	//For gloves


#define PRESSURE_DAMAGE_COEFFICIENT			4		//The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE
#define MAX_HIGH_PRESSURE_DAMAGE			4		//This used to be 20... I got this much random rage for some retarded decision by polymorph?! Polymorph now lies in a pool of blood with a katana jammed in his spleen. ~Errorage --PS: The katana did less than 20 damage to him :(
#define LOW_PRESSURE_DAMAGE					2		//The amounb of damage someone takes when in a low pressure area (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).

#define PRESSURE_SUIT_REDUCTION_COEFFICIENT 0.8		//This is how much (percentual) a suit with the flag STOPSPRESSUREDMAGE reduces pressure.
#define PRESSURE_HEAD_REDUCTION_COEFFICIENT 0.4		//This is how much (percentual) a helmet/hat with the flag STOPSPRESSUREDMAGE reduces pressure.



//Additional code for the above flags.
#ifdef dellogging
#warn compiling del logging. This will have additional overheads.	//will warn you if compiling with dellogging
var/list/del_counter = list()
/proc/log_del(datum/X)
	if(istype(X)){del_counter[X.type]++;}
	del(X)
#define del(X) log_del(X)							//overrides all del() calls with log_del()
#endif

#ifdef TESTING
#warn compiling in TESTING mode. testing() debug messages will be visible.
#endif