// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 126.00f; // giving her buff in range was :240:
const int TELEPORT_FREQUENCY = 90; //4 secs
const int TELEPORT_DISTANCE = 20;//getMap().tilesize;


const f32 max_rangeA = 252.00f; // giving her buff in range was :240:
const int TELEPORT_FREQUENCYA = 15; //4 secs
const int TELEPORT_DISTANCEA = 20;//getMap().tilesize;
void onInit(CBlob@ this)
{

	this.set_u32("last teleport", 0 );
	this.set_bool("teleport ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("tep");
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("teleport ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("tep") && (this.getHealth()>15.0))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if(ready) {
				//
				if(this.hasTag("tep")) {
					Vec2f delta = this.getPosition() - blob.getPosition();
					if(delta.Length() > TELEPORT_DISTANCE )
					{
						this.set_u32("last teleport", gametime);
						this.set_bool("teleport ready", false );
						if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
						{
							server_CreateBlob("slate", -1, blob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
							//MakeParticleLine(this.getPosition(), blob.getPosition(), 50);
							if(blob.hasTag("player")) {
								break; // we only want to hit 1 zombie at a time
							}
						}
					} 	

			}
		} 
	
		else {		
			u32 lastTeleport = this.get_u32("last teleport");
			int diff = gametime - (lastTeleport + TELEPORT_FREQUENCY);
		

			if (diff > 0)
			{
				this.set_bool("teleport ready", true );
			}
		}
			
		}
	}
	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_rangeA, @blobs) && this.hasTag("tep") && (this.getHealth()<15.0))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if(ready) {
				//
				if(this.hasTag("tep")) {
					Vec2f delta = this.getPosition() - blob.getPosition();
					if(delta.Length() > TELEPORT_DISTANCEA )
					{
						this.set_u32("last teleport", gametime);
						this.set_bool("teleport ready", false );
						if(blob.hasTag("flesh") && blob.getTeamNum() != this.getTeamNum())
						{
							server_CreateBlob("slate", -1, blob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
							//MakeParticleLine(this.getPosition(), blob.getPosition(), 50);
							if(blob.hasTag("player")) {
								break; // we only want to hit 1 zombie at a time
							}
						}
					} 	

			}
		} 
	
		else {		
			u32 lastTeleport = this.get_u32("last teleport");
			int diff = gametime - (lastTeleport + TELEPORT_FREQUENCYA);
		

			if (diff > 0)
			{
				this.set_bool("teleport ready", true );
			}
		}
			
		}
	}
}
