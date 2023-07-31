// Knockback on hit - put before any damaging things but after any scalers
#include "Hitters_mod.as"

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	f32 x_side = 0.0f;
	f32 y_side = 0.0f;
	//if (hitterBlob !is null)
	{
		//Vec2f dif = hitterBlob.getPosition() - this.getPosition();
		if (velocity.x > 0.7)
		{
			x_side = 1.0f;
		}
		else if (velocity.x < -0.7)
		{
			x_side = -1.0f;
		}

		if (velocity.y > 0.5)
		{
			y_side = 1.0f;
		}
		else
		{
			y_side = -1.0f;
		}
	}
	f32 scale = 1.0f;

	//scale per hitter
	switch (customData)
	{
		case Hitters_mod::fall:
		case Hitters_mod::drown:
		case Hitters_mod::burn:
		case Hitters_mod::crush:
		case Hitters_mod::spikes:
			scale = 0.0f; break;

		case Hitters_mod::arrow:
			scale = 0.0f; break;

		case Hitters_mod::cata_stones:
			scale = 0.25f; break;

		default: break;
	}

	Vec2f f(x_side, y_side);

	if (damage > 0.125f)
	{
		if (this.hasTag("portal_zombie") || this.hasTag("zombie")){
			this.AddForce(f * 40.0f * scale * Maths::Log(2.0f * (10.0f + (damage * 2.0f))) * 0.45f);
			// this.AddForce(toadd);
		}
		else{
			this.AddForce(f * 40.0f * scale * Maths::Log(2.0f * (10.0f + (damage * 2.0f))));
		}
	}

	return damage; //damage not affected
}
