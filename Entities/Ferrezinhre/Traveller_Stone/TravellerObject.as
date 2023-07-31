// Lantern script
#include "Knocked.as";
#include "Hitters_mod.as";
#include "GenericButtonCommon.as";
const f32 max_range = 55200.00f; // range change due maps size
const int TELEPORT_FREQUENCY = 30; //4 secs
const int TELEPORT_DISTANCE = 180;//getMap().tilesize;


void onInit(CBlob@ this)
{
	this.addCommandID("activate");
	this.set_u32("last teleport", 0 );
	this.set_bool("teleport ready", true );
	this.Tag("tep");
	this.Tag("recaller");
}


void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;
    if (!this.isAttachedTo(caller)) return;

	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton(11, Vec2f_zero, this, this.getCommandID("activate"), "Activate", params);
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("activate"))
	{

  bool ready = this.get_bool("teleport ready");
	const u32 gametime = getGameTime();
	CBlob@[] blobs;

	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("tep"))
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
				this.set_bool("teleport ready", true );
				if(blob.hasTag("recaller"))
				{
				MakeParticleLine(this.getPosition() + Vec2f(0, -12), blob.getPosition(), 150);
				MakeParticleLine2(this.getPosition() + Vec2f(0, -8), blob.getPosition(), 150);
				MakeParticleLine3(this.getPosition() + Vec2f(0, -4), blob.getPosition(), 150);
				MakeParticleLine4(this.getPosition() + Vec2f(0, 0), blob.getPosition(), 150);
				MakeParticleLine5(this.getPosition() + Vec2f(0, 4), blob.getPosition(), 150);
				MakeParticleLine6(this.getPosition() + Vec2f(0, 8), blob.getPosition(), 150);
				MakeParticleLine7(this.getPosition() + Vec2f(0, 12), blob.getPosition(), 150);
				Teleport(this, blob.getOldPosition());
				}
			} 	

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
	blob.getSprite().PlaySound("/Trvl.ogg");
}


void onThisAddToInventory( CBlob@ this, CBlob@ inventoryBlob )
{
	this.doTickScripts = true;
}


void onDie(CBlob@ this)
{
	this.getSprite().Gib();
}


bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return this.getTeamNum() == blob.getTeamNum();
}

void MakeParticleLine(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 0;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 255, 0, 0), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine2(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 1;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 255, 127, 0), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine3(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 3;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 255, 255, 0), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine4(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 4;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 0, 255, 0), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine5(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 5;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 0, 0, 255), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine6(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 6;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 75, 0, 130), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}

void MakeParticleLine7(Vec2f start, Vec2f end, int density)
{
	Vec2f dist = end - start;
	for (int i = 0; i < density; i++)
	{
		Vec2f pos = start + dist * (float(i) / density);
		f32 radius = 7;
        Vec2f offset = Vec2f(radius, 1);
        offset.RotateByDegrees(XORRandom(3600) * 1.1f);
        Vec2f vel = -offset;
        vel.Normalize();
        vel *= 0.25f;
        vel.RotateByDegrees(XORRandom(3600) * 1.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 148, 0, 211), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}
