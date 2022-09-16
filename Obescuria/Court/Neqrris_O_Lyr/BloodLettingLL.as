// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 6900.00f;
const int bloodletting_FREQUENCY = 60; //4 secs
const int bloodletting_DISTANCE = 1;//getMap().tilesize;

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

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("bld") && (this.getHealth()>0.5)) // I would make it slight stronger now
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
				if(blob.hasTag("player"))
				{
				this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 1.5f, Hitters::fall);
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
			this.getSprite().PlaySound("/sand_fall.ogg"); 
		}
	}
			
		}
	}
}


bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}

void bloodletting( CBlob@ blob, Vec2f pos){	
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
