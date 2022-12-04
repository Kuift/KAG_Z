// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range_of_neqrris_rage = 2844.00f;
const int NEQRRIS_RAGE_FREQUENCY = 30;
const int NEQRRIS_RAGE_FREQUENCY2 = 15; //4 secs
const int NEQRRIS_RAGE_DISTANCE = 1;//getMap().tilesize;

void onInit(CBlob@ this)
{

	this.set_u32("last outburst", 0 );
	this.set_bool("outburst ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("rage");
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("outburst ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	if(this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range_of_neqrris_rage, @blobs) && this.hasTag("rage") && this.getHealth() > 0.5f) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("rage")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > NEQRRIS_RAGE_DISTANCE )
				{
				this.set_u32("last outburst", gametime);
				this.set_bool("outburst ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				server_CreateBlob("neqrrisrage", -1, this.getPosition() + Vec2f(0 - XORRandom(300), 0.0f - XORRandom(160)));
				server_CreateBlob("neqrrisrage", -1, this.getPosition() + Vec2f(0 + XORRandom(300), 0.0f - XORRandom(160)));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastTeleport = this.get_u32("last outburst");
		int diff = gametime - (lastTeleport + NEQRRIS_RAGE_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("outburst ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
	else if(this.hasTag("PhaseFour"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range_of_neqrris_rage, @blobs) && this.hasTag("rage") && this.getHealth() > 0.5f) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("rage")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > NEQRRIS_RAGE_DISTANCE )
				{
				this.set_u32("last outburst", gametime);
				this.set_bool("outburst ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				server_CreateBlob("neqrrisrage", -1, this.getPosition() + Vec2f(0 - XORRandom(300), 0.0f - XORRandom(160)));
				server_CreateBlob("neqrrisrage", -1, this.getPosition() + Vec2f(0 + XORRandom(300), 0.0f - XORRandom(160)));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastTeleport = this.get_u32("last outburst");
		int diff = gametime - (lastTeleport + NEQRRIS_RAGE_FREQUENCY2);
		

		if (diff > 0)
		{
			this.set_bool("outburst ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
}
