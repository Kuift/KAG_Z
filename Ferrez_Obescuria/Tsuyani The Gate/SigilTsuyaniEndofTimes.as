// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 340282350000000000000000000000000000000.00f;
const int Attack_FREQUENCY = 45; //4 secs
const int Attack_DISTANCE = 1;//getMap().tilesize;

void onInit(CBlob@ this)
{

	this.set_u32("last attack", 0 );
	this.set_bool("attack ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("NOI");
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("attack ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("NOI"))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("NOI")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > Attack_DISTANCE )
				{
				this.set_u32("last attack", gametime);
				this.set_bool("attack ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				server_CreateBlob("tsuyaniwill", -1, blob.getPosition() + Vec2f(0 - XORRandom(300), 0.0f - XORRandom(160)));
				server_CreateBlob("tsuyaniwill", -1, blob.getPosition() + Vec2f(0 + XORRandom(300), 0.0f - XORRandom(160)));
				server_CreateBlob("tsuyaniwill", -1, blob.getPosition() + Vec2f(0 , 0.0f - XORRandom(160)));
				if(blob.hasTag("player")) {
								break; // we only want to hit 1 zombie at a time
							}
				}
			} 	

		}
	} 
	
		else {		
		u32 lastAttack = this.get_u32("last attack");
		int diff = gametime - (lastAttack + Attack_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("attack ready", true );

		}
	}
			
		}
	}
}
