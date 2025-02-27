/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

//Misc mob defines

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1
#define PLAYER_READY_TO_OBSERVE 2

//Game mode list indexes
#define CURRENT_LIVING_PLAYERS	"living_players_list"
#define CURRENT_LIVING_ANTAGS	"living_antags_list"
#define CURRENT_DEAD_PLAYERS	"dead_players_list"
#define CURRENT_OBSERVERS		"current_observers_list"

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"

//Blood volumes, in cL
#define BLOOD_VOLUME_MAX_LETHAL		2150 // The lethal amount for a good semaritan, based off IRL data about vampires
#define BLOOD_VOLUME_GENERIC		560 // The default amount of blood in a blooded creature, in cL, based off IRL data about humans
#define BLOOD_VOLUME_MONKEY			325 // Based on IRL data bout Chimpanzees
#define BLOOD_VOLUME_XENO			700 // Based off data from my asshole

#define BLOOD_VOLUME_SLIME_SPLIT	(2.0 * BLOOD_VOLUME_GENERIC) // Amount of blood needed by slimebois for splitting in twain

//Blood multiplers -- Multiply the original default value of blood your Carbon has with these in order to get the actual blood tiers
// i.e.	if(h.blood_volume < initial(h.blood_volume) * BLOOD_OKAY_MULTI) or whatever
//used by :living/proc/get_blood_state()
#define BLOOD_MAXIMUM_MULTI 3.6 // 360%
#define BLOOD_SAFE_MULTI 0.848	// 84.8%
#define BLOOD_OKAY_MULTI 0.6	// 60%
#define BLOOD_BAD_MULTI 0.4		// 40%
#define BLOOD_SURVIVE_MULTI 0.2	// 20%

//Blood state enums, again used by get_blood_state()
#define BLOOD_MAXIMUM 5
#define BLOOD_SAFE 4
#define BLOOD_OKAY 3
#define BLOOD_BAD 2
#define BLOOD_SURVIVE 1
#define BLOOD_DEAD 0

//Defines to get the actual volumes for these varying states
//YOGS: Keep in mind that in BYOND, initial() is a non-const function and doesn't work correctly in switch statements!
#define BLOOD_VOLUME_MAXIMUM(L)		(initial(##L.blood_volume) * BLOOD_MAXIMUM_MULTI)
#define BLOOD_VOLUME_NORMAL(L)		(initial(##L.blood_volume))
#define BLOOD_VOLUME_SAFE(L)		(initial(##L.blood_volume) * BLOOD_SAFE_MULTI)
#define BLOOD_VOLUME_OKAY(L)		(initial(##L.blood_volume) * BLOOD_OKAY_MULTI)
#define BLOOD_VOLUME_BAD(L)			(initial(##L.blood_volume) * BLOOD_BAD_MULTI)
#define BLOOD_VOLUME_SURVIVE(L)		(initial(##L.blood_volume) * BLOOD_SURVIVE_MULTI)

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3
#define MOB_SIZE_HUGE 4

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Bloodcrawling defines
#define BLOODCRAWL 1
#define BLOODCRAWL_EAT 2

//Mob bio-types
#define MOB_ORGANIC 	(1<<0)
#define MOB_INORGANIC 	(1<<1)
#define MOB_ROBOTIC 	(1<<2)
#define MOB_UNDEAD		(1<<3)
#define MOB_HUMANOID 	(1<<4)
#define MOB_BUG 		(1<<5)
#define MOB_BEAST		(1<<6)
#define MOB_EPIC		(1<<7) //megafauna
#define MOB_REPTILE		(1<<8)
#define MOB_SPIRIT		(1<<9)
#define MOB_SPECIAL		(1<<10) //eldritch biggums


/// All the biotypes that matter
#define ALL_NON_ROBOTIC (MOB_ORGANIC|MOB_INORGANIC|MOB_UNDEAD)
#define ALL_BIOTYPES (MOB_ORGANIC|MOB_INORGANIC|MOB_ROBOTIC|MOB_UNDEAD)

// Defines for Species IDs. Used to refer to the name of a species, for things like bodypart names or species preferences.
#define SPECIES_ABDUCTOR "abductor"
#define SPECIES_DULLAHAN "dullahan"
#define SPECIES_ETHEREAL "ethereal"
#define SPECIES_FELINE "felinid"
#define SPECIES_FLYPERSON "fly"
#define SPECIES_HUMAN "human"

#define SPECIES_JELLYPERSON "jelly"
#define SPECIES_SLIMEPERSON "slime"
#define SPECIES_LUMINESCENT "lum" //for some reason it's just lum in our codebase and i don't want to break stuff by changing it
#define SPECIES_STARGAZER "stargazer"
#define SPECIES_LIZARD "lizard"
#define SPECIES_LIZARD_ASH "ashlizard"
#define SPECIES_LIZARD_DRACONID "draconid"

#define SPECIES_NIGHTMARE "nightmare"
#define SPECIES_MOTH "moth"
#define SPECIES_MUSHROOM "mush"
#define SPECIES_PODPERSON "pod"
#define SPECIES_SHADOW "shadow"
#define SPECIES_SKELETON "skeleton"
#define SPECIES_SNAIL "snail"
#define SPECIES_VAMPIRE "vampire"
#define SPECIES_ZOMBIE "zombie"
#define SPECIES_ZOMBIE_INFECTIOUS "memezombie"
#define SPECIES_ZOMBIE_KROKODIL "krokodil_zombie"

//Organ defines for carbon mobs
#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

// Major type
#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2

// Minor Type
#define BODYPART_SUBTYPE_ORGANIC 1
#define BODYPART_SUBTYPE_ROBOTIC 2
#define BODYPART_SUBTYPE_IPC 3

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define ALIEN_BODYPART "alien"
#define LARVA_BODYPART "larva"
#define DEVIL_BODYPART "devil"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

// Health/damage defines for carbon mobs
#define HUMAN_MAX_OXYLOSS 3
#define HUMAN_CRIT_MAX_OXYLOSS (SSmobs.wait/30)

#define STAMINA_REGEN_BLOCK_TIME (10 SECONDS)

#define HEAT_DAMAGE_LEVEL_1 2 //Amount of damage applied when your body temperature just passes the 360.15k safety point
#define HEAT_DAMAGE_LEVEL_2 3 //Amount of damage applied when your body temperature passes the 400K point
#define HEAT_DAMAGE_LEVEL_3 8 //Amount of damage applied when your body temperature passes the 460K point and you are on fire

#define COLD_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when your body temperature just passes the 260.15k safety point
#define COLD_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when your body temperature passes the 200K point
#define COLD_DAMAGE_LEVEL_3 3 //Amount of damage applied when your body temperature passes the 120K point

//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special
#define BRAIN_TRAUMA_MAGIC /datum/brain_trauma/magic

#define TRAUMA_RESILIENCE_BASIC 1      //Curable with chems
#define TRAUMA_RESILIENCE_SURGERY 2    //Curable with brain surgery
#define TRAUMA_RESILIENCE_LOBOTOMY 3   //Curable with lobotomy
#define TRAUMA_RESILIENCE_WOUND 4    //Curable by healing the head wound
#define TRAUMA_RESILIENCE_MAGIC 5      //Curable only with magic
#define TRAUMA_RESILIENCE_ABSOLUTE 6   //This is here to stay

//Limit of traumas for each resilience tier
#define TRAUMA_LIMIT_BASIC 3
#define TRAUMA_LIMIT_SURGERY 2
#define TRAUMA_LIMIT_WOUND 2
#define TRAUMA_LIMIT_LOBOTOMY 3
#define TRAUMA_LIMIT_MAGIC 3
#define TRAUMA_LIMIT_ABSOLUTE INFINITY

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Surgery Defines
#define BIOWARE_GENERIC "generic"
#define BIOWARE_NERVES "nerves"
#define BIOWARE_CIRCULATION "circulation"
#define BIOWARE_LIGAMENTS "ligaments"

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Moods levels for humans
#define MOOD_LEVEL_HAPPY4 15
#define MOOD_LEVEL_HAPPY3 10
#define MOOD_LEVEL_HAPPY2 6
#define MOOD_LEVEL_HAPPY1 2
#define MOOD_LEVEL_NEUTRAL 0
#define MOOD_LEVEL_SAD1 -3
#define MOOD_LEVEL_SAD2 -12
#define MOOD_LEVEL_SAD3 -18
#define MOOD_LEVEL_SAD4 -25

// Mob Caps
#define MAX_WALKINGMUSHROOM 50

//Sanity levels for humans
#define SANITY_GREAT 125
#define SANITY_NEUTRAL 100
#define SANITY_DISTURBED 75
#define SANITY_UNSTABLE 50
#define SANITY_CRAZY 25
#define SANITY_INSANE 0

//Nutrition levels for humans
#define NUTRITION_LEVEL_FAT 600
#define NUTRITION_LEVEL_FULL 550
#define NUTRITION_LEVEL_MOSTLY_FULL 500
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED 350
#define NUTRITION_LEVEL_HUNGRY 250
#define NUTRITION_LEVEL_STARVING 150

#define NUTRITION_LEVEL_START_MIN 300
#define NUTRITION_LEVEL_START_MAX 350

#define HYDRATION_LEVEL_FULL 1000
#define HYDRATION_LEVEL_HYDRATED 700
#define HYDRATION_LEVEL_SMALLTHIRST 500
#define HYDRATION_LEVEL_THIRSTY 300
#define HYDRATION_LEVEL_DEHYDRATED 100

#define HYDRATION_LEVEL_START_MIN 500
#define HYDRATION_LEVEL_START_MAX 600

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25

//Used as an upper limit for species that continuously gain nutriment
#define NUTRITION_LEVEL_ALMOST_FULL 535

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime extract crossing. Controls how many extracts is required to feed to a slime to core-cross.
#define SLIME_EXTRACT_CROSSING_REQUIRED 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
// #define SENTIENCE_OTHER 3 unused
#define SENTIENCE_MINEBOT 4
#define SENTIENCE_BOSS 5

//Mob AI Status

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON		1
#define AI_IDLE		2
#define AI_OFF		3
#define AI_Z_OFF	4

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE			0
#define ENVIRONMENT_SMASH_STRUCTURES	(1<<0) 	//crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS			(1<<1)  //walls
#define ENVIRONMENT_SMASH_RWALLS		(1<<2)	//rwalls

// Slip flags, also known as lube flags
/// The mob will not slip if they're walking intent
#define NO_SLIP_WHEN_WALKING (1<<0)
/// Slipping on this will send them sliding a few tiles down
#define SLIDE (1<<1)
/// Ice slides only go one tile and don't knock you over, they're intended to cause a "slip chain"
/// where you slip on ice until you reach a non-slippable tile (ice puzzles)
#define SLIDE_ICE (1<<2)
/// [TRAIT_NO_SLIP_WATER] does not work on this slip. ONLY [TRAIT_NO_SLIP_ALL] will
#define GALOSHES_DONT_HELP (1<<3)
/// Slip works even if you're already on the ground
#define SLIP_WHEN_CRAWLING (1<<4)
/// the mob won't slip if the turf has the TRAIT_TURF_IGNORE_SLIPPERY trait.
#define SLIPPERY_TURF (1<<5)

#define MAX_CHICKENS 50


#define INCORPOREAL_MOVE_BASIC 1
#define INCORPOREAL_MOVE_SHADOW 2 // leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 // is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED		(1<<0)
#define JUDGE_IDCHECK		(1<<1)
#define JUDGE_WEAPONCHECK	(1<<2)
#define JUDGE_RECORDCHECK	(1<<3)
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS	(1<<4)

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_DIM_LIGHT 0.2 //light of this intensity suppresses healing and causes very slow burn damage
#define SHADOW_SPECIES_BRIGHT_LIGHT 0.6 //light of this intensity causes rapid burn damage (high number because movable lights are weird)
//so the problem is that movable lights ALWAYS have a luminosity of 0.5, regardless of power or distance, so even at the edge of the overlay they still do damage
//at 0.6 being bright they'll still do damage and disable some abilities, but it won't be weaponized

// Offsets defines

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "id"
#define OFFSET_GLOVES "gloves"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face"
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"

//MINOR TWEAKS/MISC
#define AGE_MIN				18	//youngest a character can be
#define AGE_MAX				60	//oldest a character can be
#define AGE_MINOR			18  //legal age of space drinking and smoking
#define WIZARD_AGE_MIN		30	//youngest a wizard can be
#define APPRENTICE_AGE_MIN	29	//youngest an apprentice can be
#define SHOES_SLOWDOWN		0	//How much shoes slow you down by default. Negative values speed you up
#define POCKET_STRIP_DELAY	(4 SECONDS) //time taken to search somebody's pockets
#define DOOR_CRUSH_DAMAGE	15	//the amount of damage that airlocks deal when they crush you

#define	HUNGER_FACTOR		0.15	//factor at which mob nutrition or thirst decreases
#define	REAGENTS_METABOLISM 0.4	//How many units of reagent are consumed per tick, by default.
#define REAGENTS_EFFECT_MULTIPLIER (REAGENTS_METABOLISM / 0.4)	// By defining the effect multiplier this way, it'll exactly adjust all effects according to how they originally were with the 0.4 metabolism

// Eye protection
#define FLASH_PROTECTION_HYPER_SENSITIVE -2
#define FLASH_PROTECTION_SENSITIVE -1
#define FLASH_PROTECTION_NONE 0
#define FLASH_PROTECTION_FLASH 1
#define FLASH_PROTECTION_WELDER 2

// Roundstart trait system

#define MAX_QUIRKS 6 //The maximum amount of quirks one character can have at roundstart

// AI Toggles
#define AI_CAMERA_LUMINOSITY	5
#define AI_VOX // Comment out if you don't want VOX to be enabled and have players download the voice sounds.

// /obj/item/bodypart on_mob_life() retval flag
#define BODYPART_LIFE_UPDATE_HEALTH (1<<0)

#define MAX_REVIVE_FIRE_DAMAGE 180
#define MAX_REVIVE_BRUTE_DAMAGE 180

#define HUMAN_FIRE_STACK_ICON_NUM	3

#define GRAB_PIXEL_SHIFT_PASSIVE 6
#define GRAB_PIXEL_SHIFT_AGGRESSIVE 12
#define GRAB_PIXEL_SHIFT_NECK 16

#define PULL_PRONE_SLOWDOWN 1.5
#define HUMAN_CARRY_SLOWDOWN 0.35

//Flags that control what things can spawn species (whitelist)
//Badmin magic mirror
#define MIRROR_BADMIN (1<<0)
//Standard magic mirror (wizard)
#define MIRROR_MAGIC  (1<<1)
//Pride ruin mirror
#define MIRROR_PRIDE  (1<<2)
//Race swap wizard event
#define RACE_SWAP     (1<<3)
//ERT spawn template (avoid races that don't function without correct gear)
#define ERT_SPAWN     (1<<4)
//xenobio black crossbreed
#define SLIME_EXTRACT (1<<5)
//Wabbacjack staff projectiles
#define WABBAJACK     (1<<6)

#define SLEEP_CHECK_DEATH(X) sleep(X); if(QDELETED(src) || stat == DEAD) return;

// recent examine defines
/// How long it takes for an examined atom to be removed from recent_examines. Should be the max of the below time windows
#define RECENT_EXAMINE_MAX_WINDOW 2 SECONDS
/// If you examine the same atom twice in this timeframe, we call examine_more() instead of examine()
#define EXAMINE_MORE_WINDOW 1 SECONDS
/// If you examine another mob who's successfully examined you during this duration of time, you two try to make eye contact. Cute!
#define EYE_CONTACT_WINDOW 2 SECONDS
/// If you yawn while someone nearby has examined you within this time frame, it will force them to yawn as well. Tradecraft!
#define YAWN_PROPAGATION_EXAMINE_WINDOW 2 SECONDS

/// How far away you can be to make eye contact with someone while examining
#define EYE_CONTACT_RANGE 5

//this should be in the ai defines, but out ai defines are actual ai, not simplemob ai
#define IS_DEAD_OR_INCAP(source) (source.incapacitated() || source.stat)

#define DOING_INTERACTION(user, interaction_key) (LAZYACCESS(user.do_afters, interaction_key))
#define DOING_INTERACTION_LIMIT(user, interaction_key, max_interaction_count) ((LAZYACCESS(user.do_afters, interaction_key) || 0) >= max_interaction_count)
#define DOING_INTERACTION_WITH_TARGET(user, target) (LAZYACCESS(user.do_afters, target))
#define DOING_INTERACTION_WITH_TARGET_LIMIT(user, target, max_interaction_count) ((LAZYACCESS(user.do_afters, target) || 0) >= max_interaction_count)

///Define for spawning megafauna instead of a mob for cave gen
#define SPAWN_MEGAFAUNA "bluh bluh huge boss"

///Swarmer flags
#define SWARMER_LIGHT_ON (1<<0)

#define ACCENT_NONE "None"

// Body position defines.
/// Mob is standing up, usually associated with lying_angle value of 0.
#define STANDING_UP 0
/// Mob is lying down, usually associated with lying_angle values of 90 or 270.
#define LYING_DOWN 1

/// Possible value of [/atom/movable/buckle_lying]. If set to a different (positive-or-zero) value than this, the buckling thing will force a lying angle on the buckled.
#define NO_BUCKLE_LYING -1

/// Squashing will not occur if the mob is not lying down (bodyposition is LYING_DOWN)
#define SQUASHED_SHOULD_BE_DOWN (1<<0)
/// If present, outright gibs the squashed mob instead of just dealing damage
#define SQUASHED_SHOULD_BE_GIBBED (1<<1)
/// If squashing always passes if the mob is dead
#define SQUASHED_ALWAYS_IF_DEAD (1<<2)
/// Don't squash our mob if its not located in a turf
#define SQUASHED_DONT_SQUASH_IN_CONTENTS (1<<3)

// Bitflags for mob dismemberment and gibbing
/// Mobs will drop a brain
#define DROP_BRAIN (1<<0)
/// Mobs will drop organs
#define DROP_ORGANS (1<<1)
/// Mobs will drop bodyparts (arms, legs, etc.)
#define DROP_BODYPARTS (1<<2)
/// Mobs will drop items
#define DROP_ITEMS (1<<3)

/// Mobs will drop everything
#define DROP_ALL_REMAINS (DROP_BRAIN | DROP_ORGANS | DROP_BODYPARTS | DROP_ITEMS)

// Sprites for photocopying butts
#define BUTT_SPRITE_HUMAN_MALE "human_male"
#define BUTT_SPRITE_HUMAN_FEMALE "human_female"
#define BUTT_SPRITE_LIZARD "lizard"
#define BUTT_SPRITE_QR_CODE "qr_code"
#define BUTT_SPRITE_XENOMORPH "xeno"
#define BUTT_SPRITE_DRONE "drone"
#define BUTT_SPRITE_CAT "cat"
#define BUTT_SPRITE_FLOWERPOT "flowerpot"
#define BUTT_SPRITE_GREY "grey"
#define BUTT_SPRITE_PLASMA "plasma"
#define BUTT_SPRITE_FUZZY "fuzzy"
#define BUTT_SPRITE_SLIME "slime"
