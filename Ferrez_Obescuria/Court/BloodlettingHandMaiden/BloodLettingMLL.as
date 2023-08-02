// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 160.00f;
const int TELEPORT_FREQUENCY = 90; //4 secs
const int TELEPORT_DISTANCE = 1;//getMap().tilesize;

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

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("tep") && (this.getHealth()>0.5))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			if(ready) {
				if(this.hasTag("tep")) {
					Vec2f delta = this.getPosition() - blob.getPosition();
					if(delta.Length() > TELEPORT_DISTANCE )
					{
						this.set_u32("last teleport", gametime);
						this.set_bool("teleport ready", false );
						if(blob.hasTag("player") || blob.hasTag("fanatic"))
						{
							this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 1.0f, Hitters::fall);
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
					//this.getSprite().PlaySound("/sand_fall.ogg"); 
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
