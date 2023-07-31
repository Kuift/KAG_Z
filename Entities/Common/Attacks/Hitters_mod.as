
namespace Hitters_mod
{
	shared enum hits
	{
		nothing = 0,

		//env
		crush = 1, //(required to be 1 for engine reasons)
		fall,
		water,      //just fire
		water_stun, //splash
		water_stun_force, //splash
		drown,
		fire,   //initial burst (should ignite things)
		burn,   //burn damage
		flying,

		//common actor
		stomp,
		suicide = 11, //(required to be 11 for engine reasons)

		//natural
		bite,

		//builders
		builder,

		//knight
		sword,
		shield,
		bomb,

		//archer
		stab,
		
		//custom hitters
		notnormalfire, 
		arc,
		blast,
		noise,

		//arrows and similar projectiles
		arrow,
		bomb_arrow,
		ballista,

		//cata
		cata_stones,
		cata_boulder,
		boulder,

		//siege
		ram,

		// explosion
		explosion,
		keg,
		mine,
		mine_special,

		//traps
		spikes,

		//machinery
		saw,
		drill,

		//barbarian
		muscles,

		// scrolls
		suddengib
	};
}

// not keg - not blockable :)
bool isExplosionHitter(u8 type)
{
	return type == Hitters_mod::bomb || type == Hitters_mod::explosion || type == Hitters_mod::mine || type == Hitters_mod::bomb_arrow || type == Hitters_mod::blast;
}
