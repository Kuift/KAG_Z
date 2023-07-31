// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 32.00f;
const float field_force = 1.0;
const float mass = 1.0;

const float first_radius = 64.0;
const float second_radius = 220.0;

u16 MAX_BOSS = 4;

void onInit(CBlob@ this)
{


	this.getCurrentScript().tickFrequency = 1;
	this.Tag("laying");
}

void onTick(CBlob@ this)
{
	CBlob@[] blobs;
	const u32 gametime = getGameTime();
	
	if (isServer())
	{
		if(getRules().get_u32("max_cocoon") >= MAX_BOSS) {return;}
		if (this.hasTag("laying") && this.getTickSinceCreated() > 640)
		{
			server_CreateBlob("begg", -1, this.getPosition() + Vec2f(0, -5.0f));
			this.Untag("laying");
			return;
		}
	}
}
