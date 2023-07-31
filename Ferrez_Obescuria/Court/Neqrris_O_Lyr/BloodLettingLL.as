// Lantern script
#include "Knocked.as";
#include "Hitters_mod.as";
#include "FireCommon.as";
const f32 bloodletting_range = 6900.00f;
const f32 bloodletting_range2 = 128.00f;
const f32 bloodletting_range3 = 720.00f;
const f32 bloodletting_range4 = 1444.00f;
const int bloodletting_FREQUENCY = 50; //4 secs
const int bloodletting_FREQUENCY2 = 35; //4 secs
const int bloodletting_FREQUENCY3 = 35; //4 secs
const int bloodletting_FREQUENCY4 = 45; //4 secs
const int bloodletting_DISTANCE = 1;//getMap().tilesize;
const int bloodletting_DISTANCE2 = 1;//getMap().tilesize;
const int bloodletting_DISTANCE3 = 1;//getMap().tilesize;
const int bloodletting_DISTANCE4 = 1;//getMap().tilesize;


void onInit(CBlob@ this)
{

	this.set_u32("last bloodletting", 0 );
	this.set_bool("bloodletting ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("bld");
	
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("bloodletting ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;
					
						
	if(this.hasTag("PhaseOne") && !this.hasTag("PhaseTwo"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), bloodletting_range, @blobs) && this.hasTag("bld")) // I would make it slight stronger now
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("bld")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > bloodletting_DISTANCE )
				{
				this.set_u32("last bloodletting", gametime);
				this.set_bool("bloodletting ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 0.5f, Hitters_modfall);
				}
			} 	

		}
	} 
	
		else {		
		u32 lastbloodletting = this.get_u32("last bloodletting");
		int diff = gametime - (lastbloodletting + bloodletting_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("bloodletting ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
	
	else if( this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), bloodletting_range2, @blobs) && this.hasTag("bld")) // I would make it slight stronger now
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("bld")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > bloodletting_DISTANCE2 )
				{
				this.set_u32("last bloodletting", gametime);
				this.set_bool("bloodletting ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 1.5f, Hitters_modfall);
				}
			} 	

		}
	} 
	
		else {		
		u32 lastbloodletting = this.get_u32("last bloodletting");
		int diff = gametime - (lastbloodletting + bloodletting_FREQUENCY2);
		

		if (diff > 0)
		{
			this.set_bool("bloodletting ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
	
	else if( this.hasTag("PhaseThree") && !this.hasTag("PhaseFour"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), bloodletting_range3, @blobs) && this.hasTag("bld")) // I would make it slight stronger now
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("bld")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > bloodletting_DISTANCE3 )
				{
				this.set_u32("last bloodletting", gametime);
				this.set_bool("bloodletting ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 1.0f, Hitters_modfall);
				}
			} 	

		}
	} 
	
		else {		
		u32 lastbloodletting = this.get_u32("last bloodletting");
		int diff = gametime - (lastbloodletting + bloodletting_FREQUENCY3);
		

		if (diff > 0)
		{
			this.set_bool("bloodletting ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
	
	else if( this.hasTag("PhaseFour"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), bloodletting_range4, @blobs) && this.hasTag("bld")) // I would make it slight stronger now
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("bld")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > bloodletting_DISTANCE4 )
				{
				this.set_u32("last bloodletting", gametime);
				this.set_bool("bloodletting ready", false );
				if(blob.hasTag("player") || blob.hasTag("fanatic"))
				{
				this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 2.0f, Hitters_modfall);
				}
			} 	

		}
	} 
	
		else {		
		u32 lastbloodletting = this.get_u32("last bloodletting");
		int diff = gametime - (lastbloodletting + bloodletting_FREQUENCY4);
		

		if (diff > 0)
		{
			this.set_bool("bloodletting ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
	}
}



