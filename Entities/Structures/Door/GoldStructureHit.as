//scale the damage:
//      knights cant damage
//      arrows cant damage

#include "Hitters_mod.as";

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    f32 dmg = damage;
    switch(customData)
    {
    case Hitters_modbuilder:
        dmg *= 2.0f; //builder is great at smashing stuff
        break;
	case Hitters_modsaw:
		dmg *= 0.25f;
		break;
	case Hitters_modbomb:
		dmg *= 0.01f;
		case Hitters_modmine:
	dmg *= 0.01f;
		break;
	default:
		dmg=0;
		break;		 						  
    }

    return dmg;
}

