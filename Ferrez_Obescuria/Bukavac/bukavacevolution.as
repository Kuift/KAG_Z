// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 32.00f;
const float field_force = 1.0;
const float mass = 1.0;

const float first_radius = 64.0;
const float second_radius = 220.0;

void onInit(CBlob@ this)
{
	this.server_SetTimeToDie(10);
	this.getCurrentScript().tickFrequency = 1;
	this.Tag("evolving");
}

void onTick(CBlob@ this)
{
	CBlob@[] blobs;
	const u32 gametime = getGameTime();
		
	if (isServer())
	{
		if (this.hasTag("evolving") && this.getTickSinceCreated() > 290)
		{
			server_CreateBlob("Cocon", -1, this.getPosition() + Vec2f(0, -5.0f));
			this.Untag("evolving");
		}
	}
}
