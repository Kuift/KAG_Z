// Lantern script
#include "Knocked.as";
#include "/Entities/Common/Attacks/Hitters.as";
#include "FireCommon.as";
const f32 max_range = 6900.00f;
const int SUMMON_FREQUENCY = 180; //4 secs
const int SUMMON_FREQUENCY2 = 60; //4 secs
const int SUMMON_DISTANCE = 1;//getMap().tilesize;
const int MAX_TOTEMS = 8;
void onInit(CBlob@ this)
{

	this.set_u32("last summon", 0 );
	this.set_bool("summon ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("OGNA");
	this.set_u32("totem_summon", 0);
}

void onTick(CBlob@ this)
{

  bool ready = this.get_bool("summon ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("OGNA"))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];

			if(ready) {
				if(this.hasTag("OGNA")) {
					Vec2f delta = this.getPosition() - blob.getPosition();
					if(delta.Length() > SUMMON_DISTANCE )
					{
						this.set_u32("last summon", gametime);
						this.set_bool("summon ready", false );
						if(this.hasTag("EndlessFlame") && this.get_u32("totem_summon") < MAX_TOTEMS)
						{
							CBlob@ totem1 = server_CreateBlob("fyrnigh", -1, this.getOldPosition() + Vec2f(0, -5.0f));
							uint16 fyllidID = this.getNetworkID();
							totem1.set_u16("fyllidID", fyllidID);
							this.set_u32("totem_summon", this.get_u32("totem_summon") + 2);
						}
					} 	
				}
			} 
	
			else {		
				u32 lastSummon = this.get_u32("last summon");
				int diff = gametime - (lastSummon + SUMMON_FREQUENCY);
			

				if (diff > 0)
				{
					this.set_bool("summon ready", true );
					//this.getSprite().PlaySound("/sand_fall.ogg"); 
				}
			}
		}
	}
	}
	
	if(this.hasTag("PhaseThree"))
	{
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("OGNA"))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];

			if(ready) {
				if(this.hasTag("OGNA")) {
					Vec2f delta = this.getPosition() - blob.getPosition();
					if(delta.Length() > SUMMON_DISTANCE )
					{
						this.set_u32("last summon", gametime);
						this.set_bool("summon ready", false );
						if(blob.hasTag("player") && this.get_u32("totem_summon") < MAX_TOTEMS)
						{
							CBlob@ totem1 = server_CreateBlob("fyrnigh", -1, blob.getOldPosition() + Vec2f(0, -5.0f));
							uint16 fyllidID = this.getNetworkID();
							totem1.set_u16("fyllidID", fyllidID);
							this.set_u32("totem_summon", this.get_u32("totem_summon") + 2);
						}
					} 	
				}
			} 
	
			else {		
				u32 lastSummon = this.get_u32("last summon");
				int diff = gametime - (lastSummon + SUMMON_FREQUENCY2);
			

				if (diff > 0)
				{
					this.set_bool("summon ready", true );
					//this.getSprite().PlaySound("/sand_fall.ogg"); 
				}
			}
		}
	}
	}
}


bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}

void Teleport( CBlob@ blob, Vec2f pos){	
	AttachmentPoint@[] ap;
	blob.getAttachmentPoints(ap);
	blob.hasTag("flesh");
	for (uint i = 0; i < ap.length; i++){
		if(!ap[i].socket && ap[i].getOccupied() !is null){
			@blob = ap[i].getOccupied();
			break;
		}
	}
	blob.setPosition( pos );
	blob.setVelocity( Vec2f_zero );	
	blob.getSprite().PlaySound("/gasp.ogg");
}