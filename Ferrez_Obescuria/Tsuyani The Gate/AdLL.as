// Lantern script
#include "Knocked.as";
#include "/Entities/Common/Attacks/Hitters.as";
const f32 max_range = 9999999999.00f;
const float field_force = 1.0;
const float mass = 1.0;

const float first_radius = 64.0;
const float second_radius = 220.0;
void onInit(CBlob@ this)
{

	this.Tag("dont deactivate");
	this.Tag("ner");
}

void onDie(CBlob@ this)
{
	CBlob@[] blobs;
	this.getCurrentScript().tickFrequency = 10;
	if (this.hasTag("ner")) 
	{
		//this.getSprite().PlaySound("/Elderithspeak.ogg");
		CBlob@[] zombies;
		getBlobsByTag("zombie", @zombies );
		for (uint i = 0; i < zombies.length; i++)
		{
			CBlob@ zombie = zombies[i];
			zombie.server_Hit(zombie, zombie.getPosition(), Vec2f(0,0), 1000.0f, Hitters::fire);
		}
		getBlobsByTag("portal_zombie", @zombies);
		for (uint i = 0; i < zombies.length; i++)
		{
			CBlob@ zombie = zombies[i];
			zombie.server_Hit(zombie, zombie.getPosition(), Vec2f(0,0), 1000.0f, Hitters::fire);
		}
		server_CreateBlob("neqrris", -1, this.getPosition() + Vec2f(0, -5.0f));
		server_CreateBlob("goresinger", -1, this.getPosition() + Vec2f(-35, -5.0f));
		server_CreateBlob("goresinger", -1, this.getPosition() + Vec2f(35, -5.0f));
		server_CreateBlob("goresinger", -1, this.getPosition() + Vec2f(35, -5.0f));
		server_CreateBlob("bloodvainguard", -1, this.getPosition() + Vec2f(-45, -5.0f));
		server_CreateBlob("bloodvainguard", -1, this.getPosition() + Vec2f(45, -5.0f));
	}
}


bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}

