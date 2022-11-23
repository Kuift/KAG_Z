#include "Knocked.as";
#include "Hitters.as";
const f32 max_range = 262.00f;
const int shok_FREQUENCY = 75; // was 60, so from 9 "shots" to 8.
const int shok_DISTANCE = 1;//getMap().tilesize;

void onInit(CBlob@ this)
{

	this.set_u32("last shok", 0 );
	this.set_bool("shok ready", true );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("shok");
}



void onTick(CBlob@ this)
{

  bool ready = this.get_bool("shok ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("shok"))
	{
	
        
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			
			
			if (!this.getMap().rayCastSolidNoBlobs(blob.getPosition(), this.getPosition()))
			{
				if(ready) {
				if(this.hasTag("shok")) {
				Vec2f delta = this.getPosition() - blob.getPosition();
				if(delta.Length() > shok_DISTANCE )
				{
				this.set_u32("last shok", gametime);
				this.set_bool("shok ready", false );
				if(blob.getTeamNum() != this.getTeamNum())
				{
				this.server_Hit(blob, blob.getPosition(), Vec2f(0,0), (1.5f*XORRandom(8)/3)*XORRandom(4), Hitters::arc);
				MakeParticleLine(this.getPosition(), blob.getPosition(), 50);
				}
			} 	

		}
	} 
	
		else {		
		u32 lastshok = this.get_u32("last shok");
		int diff = gametime - (lastshok + shok_FREQUENCY);
		

		if (diff > 0)
		{
			this.set_bool("shok ready", true );
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

void shok( CBlob@ blob, Vec2f pos){	
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
}

void MakeParticleLine(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 1;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 0.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 0.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(225, 89, 203, 232), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}
