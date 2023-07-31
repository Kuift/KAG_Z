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


	this.server_SetTimeToDie(24);
	this.getCurrentScript().tickFrequency = 1;
	this.Tag("breeding");
}

void onTick(CBlob@ this)
{
CBlob@[] blobs;
const u32 gametime = getGameTime();
	
	if (getNet().isServer())
	{
	if (this.hasTag("breeding") && this.getTickSinceCreated() - 10 > 680)
	{
	
	
		server_CreateBlob("bukavac", -1, this.getPosition() + Vec2f(0, -5.0f));
		server_CreateBlob("bukavac", -1, this.getPosition() + Vec2f(0, -5.0f));
		this.Untag("breeding");

				}
			}
		}
		
	
	
	
	


bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}

	
	bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return false;
}