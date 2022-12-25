// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 drop_range = 126.00f; // giving her buff in range was :240:
const int drop_FREQUENCY = 120; //4 secs
const int drop_DISTANCE = 20;//getMap().tilesize;


const f32 drop_rangeA = 252.00f; // giving her buff in range was :240:
const int drop_FREQUENCYA = 80; //4 secs
const int drop_FREQUENCYB = 40; //4 secs
const int drop_DISTANCEA = 20;//getMap().tilesize;
void onInit(CBlob@ this)
{

	this.set_u32("last drop", 0 );
	this.set_bool("drop ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("drop");
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("drop ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	
	if(this.hasTag("PhaseOne") && !this.hasTag("PhaseTwo"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), drop_range, @blobs)) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("drop")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > drop_DISTANCE )
				{
				this.set_u32("last drop", gametime);
				this.set_bool("drop ready", false );
				if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
				{
				server_CreateBlob("slate", -1, blob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastdrop= this.get_u32("last drop");
		int diff = gametime - (lastdrop + drop_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("drop ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
	
	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), drop_rangeA, @blobs)) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("drop")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > drop_DISTANCEA )
				{
				this.set_u32("last drop", gametime);
				this.set_bool("drop ready", false );
				if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
				{
				server_CreateBlob("slate", -1, blob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastdrop= this.get_u32("last drop");
		int diff = gametime - (lastdrop + drop_FREQUENCYA);
		

		if (diff > 0)
		{
			this.set_bool("drop ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
	
		if(this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), drop_rangeA, @blobs)) // not adding && (this.getHealth()>0.5) yet she needs some defense while downed
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			
				if(ready) {
				if(this.hasTag("drop")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > drop_DISTANCEA )
				{
				this.set_u32("last drop", gametime);
				this.set_bool("drop ready", false );
				if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
				{
				server_CreateBlob("slate", -1, blob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));

				}
			} 	

		}
	} 
	
		else {		
		u32 lastdrop= this.get_u32("last drop");
		int diff = gametime - (lastdrop + drop_FREQUENCYB);
		

		if (diff > 0)
		{
			this.set_bool("drop ready", true );
			//this.getSprite().PlaySound("/sand_fall.ogg");  // annoying sound need replace
		}
	}
			
		}
	}
	}
}
