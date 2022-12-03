//scale the damage:
//      knights cant damage
//      arrows cant damage

#include "Hitters.as";

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{
    f32 dmg = damage;
    switch(customData)
    {
    case Hitters::builder:
        dmg *= 2.0f; //builder is great at smashing stuff
        break;
	case Hitters::saw:
		dmg *= 1.25;
		break;
	case Hitters::bomb:
		dmg *= 0.5f;
		case Hitters::mine:
	dmg *= 0.5f;
		break;
	default:
		break;		 						  
    }

    return dmg;
}

