// Lantern script
#include "Knocked.as";
#include "Hitters_mod.as";
#include "FireCommon.as";
const f32 max_range = 126.00f; // giving her buff in range was :240:
const int TELEPORT_FREQUENCY = 30; //4 secs
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

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("tep") && !this.isAttached())
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
							this.server_Hit(blob, this.getPosition(), Vec2f(0,0), 1.0f, Hitters_mod::fall);
							MakeParticleLine(this.getPosition(), blob.getPosition(), 50);
							if(blob.hasTag("zombie") || blob.hasTag("ZombiePortalz")) {
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

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(225, 56, 12, 100), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}