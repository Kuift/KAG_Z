// Lantern script
#include "Knocked.as";
#include "Hitters_mod.as";
#include "FireCommon.as";
const f32 sigilbloodhold_range = 460.00f;
const f32 sigilbloodhold_range2 = 720.00f;
const f32 sigilbloodhold_range3 = 1440.00f;
const int sigilbloodhold_FREQUENCY = 180; //4 secs
const int sigilbloodhold_FREQUENCY2 = 100;
const int sigilbloodhold_FREQUENCY3 = 70; //4 secs
const int sigilbloodhold_DISTANCE = 20;//getMap().tilesize;
const int sigilbloodhold_DISTANCE2 = 40;//getMap().tilesize;
const int sigilbloodhold_DISTANCE3 = 60;

void onInit(CBlob@ this)
{

	this.set_u32("last sigilbloodhold", 0 );
	this.set_bool("sigilbloodhold ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("sigilbloodhold");
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("sigilbloodhold ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), sigilbloodhold_range, @blobs)) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("sigilbloodhold")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > sigilbloodhold_DISTANCE )
				{
				this.set_u32("last sigilbloodhold", gametime);
				this.set_bool("sigilbloodhold ready", false );
				if(blob.hasTag("player"))
				{
				server_CreateBlob("bloodrainsigil", -1, blob.getOldPosition() + Vec2f((0+XORRandom(60) -XORRandom(60)), -80.0f));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastsigilbloodhold = this.get_u32("last sigilbloodhold");
		int diff = gametime - (lastsigilbloodhold + sigilbloodhold_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("sigilbloodhold ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
	else if(this.hasTag("PhaseThree") && !this.hasTag("PhaseFour"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), sigilbloodhold_range2, @blobs) ) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("sigilbloodhold")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > sigilbloodhold_DISTANCE2 )
				{
				this.set_u32("last sigilbloodhold", gametime);
				this.set_bool("sigilbloodhold ready", false );
				if(blob.hasTag("player"))
				{
				server_CreateBlob("bloodrainsigil", -1, blob.getOldPosition() + Vec2f((0+XORRandom(60) -XORRandom(60)), -80.0f));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastsigilbloodhold = this.get_u32("last sigilbloodhold");
		int diff = gametime - (lastsigilbloodhold + sigilbloodhold_FREQUENCY2);
		

		if (diff > 0)
		{
			this.set_bool("sigilbloodhold ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
	else if(this.hasTag("PhaseFour"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), sigilbloodhold_range3, @blobs)) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("sigilbloodhold")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > sigilbloodhold_DISTANCE3 )
				{
				this.set_u32("last sigilbloodhold", gametime);
				this.set_bool("sigilbloodhold ready", false );
				if(blob.hasTag("player"))
				{
				server_CreateBlob("bloodrainsigil", -1, blob.getOldPosition() + Vec2f((0+XORRandom(60) -XORRandom(60)), -80.0f));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastsigilbloodhold = this.get_u32("last sigilbloodhold");
		int diff = gametime - (lastsigilbloodhold + sigilbloodhold_FREQUENCY3);
		

		if (diff > 0)
		{
			this.set_bool("sigilbloodhold ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
}
