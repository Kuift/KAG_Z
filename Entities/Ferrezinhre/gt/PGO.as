// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "GenericButtonCommon.as";
const f32 max_range = 275.00f;
const float field_force = 0.25;
const float mass = 1.25;
const int targets_count = 4; 
const float first_radius = 64.0;
const float second_radius = 220.0;


void onInit(CBlob@ this)
{
	this.Tag("dont deactivate");
	this.addCommandID("activate_push");
	this.addCommandID("deactivate_push");
	this.addCommandID("activate_pull");
	this.addCommandID("deactivate_pull");
	this.getCurrentScript().tickFrequency = 12;
}


void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;
    if (!this.isAttachedTo(caller)) return;

	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton(11, Vec2f(4,6), this, this.getCommandID("activate_push"), "Activate Negative Gravity Module", params);
	caller.CreateGenericButton(10, Vec2f(4,-6), this, this.getCommandID("deactivate_push"), "Deactivate Negative Gravity Module", params);
	caller.CreateGenericButton(11, Vec2f(12,6), this, this.getCommandID("activate_pull"), "Activate Positive Gravity Module", params);
	caller.CreateGenericButton(10, Vec2f(12,-6), this, this.getCommandID("deactivate_pull"), "Deactivate Positive Gravity Module", params);
}
void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
if (cmd == this.getCommandID("activate_push"))
    {
		this.Tag("ner");
	}
	
	else if ( this.hasTag("ner") && cmd == this.getCommandID("deactivate_push"))
    {
		this.Untag("ner");
	}
	
	if (cmd == this.getCommandID("activate_pull"))
    {
		this.Tag("ren");
	}
	
	else if ( this.hasTag("ren") && cmd == this.getCommandID("deactivate_pull"))
    {
		this.Untag("ren");
	}
}
void onTick(CBlob@ this)
{
CBlob@[] blobs;
	
	if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("ner"))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			if (!this.getMap().rayCastSolidNoBlobs(blob.getPosition(), this.getPosition()))
			{
				f32 dist = (blob.getPosition() - this.getPosition()).getLength();
				f32 factor = 1.00f - Maths::Pow(dist / max_range, 2);
			
				 //SetKnocked(blob, 75 * factor);
			
				if (this.hasTag("ner")) 
	{
	
	

        CBlob@[] blobs;
        getMap().getBlobsInRadius(this.getPosition(), first_radius, blobs);
        for (int i=0; i < blobs.length; i++) 
		{
		if (getPrioritisedTargets(this.getPosition(), max_range, blobs))
		{
			// print("got targets");
			for (int i = 0; i < Maths::Min(blobs.size(), targets_count); i++)
			{
            CBlob@ blob = blobs[i];
            if ( blob.getTeamNum() == this.getTeamNum() ) continue;

            Vec2f delta = blob.getPosition() - this.getPosition();

            Vec2f force = delta;
            force.Normalize();
            force *= field_force * mass * blob.getMass() * (delta.Length() / second_radius);

            blob.AddForce(force);
			MakeParticleLine(this.getPosition(), blob.getPosition(), 5);
			
        }
        }
    }
			}
		}
		}
		}
		
		if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("ren"))
	{
		for (int i = 0; i < blobs.length; i++)
		{
			CBlob@ blob = blobs[i];
			
			if (!this.getMap().rayCastSolidNoBlobs(blob.getPosition(), this.getPosition()))
			{
				f32 dist = (blob.getPosition() - this.getPosition()).getLength();
				f32 factor = 1.00f - Maths::Pow(dist / max_range, 2);
			
				 //SetKnocked(blob, 75 * factor);
			
				if (this.hasTag("ren"))
	{
	
	

        CBlob@[] blobs;
        getMap().getBlobsInRadius(this.getPosition(), first_radius, blobs);
        for (int i=0; i < blobs.length; i++) 
		{
		if (getPrioritisedTargets(this.getPosition(), max_range, blobs))
		{
			// print("got targets");
			for (int i = 0; i < Maths::Min(blobs.size(), targets_count); i++)
			{
            CBlob@ blob = blobs[i];
            if ( blob.getTeamNum() == this.getTeamNum() ) continue;

            Vec2f delta = blob.getPosition() - this.getPosition();

            Vec2f force = -delta;
            force.Normalize();
            force *= field_force * mass * blob.getMass() * (delta.Length() / second_radius);

            blob.AddForce(force);
			MakeParticleLine2(this.getPosition(), blob.getPosition(), 5);
			
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


void onThisAddToInventory( CBlob@ this, CBlob@ inventoryBlob )
{
	this.doTickScripts = true;
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

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 225, 182, 193), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}


bool getPrioritisedTargets(Vec2f pos, f32 radius, CBlob@[]@ targets)
{
	CMap@ map = getMap();
	CBlob@[] temp_targets;
	for (int i = 0; i < temp_targets.size(); i++)
	{
		CBlob@ b = temp_targets[i];
		if (b is null || (b.getPosition() - pos).Length() > max_range)
		{
			temp_targets.removeAt(i);
			i--;
		}
	}


	return targets.size() > 0;
}

void MakeParticleLine2(Vec2f start, Vec2f end, int density)
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
        vel *= 0.5f;
        vel.RotateByDegrees(XORRandom(3600) * 0.1f);

        CParticle@ p = ParticlePixel(pos + offset, vel, SColor(222, 100, 149, 237), true, 2);
        if (p !is null)
        {
			p.gravity = Vec2f(0,0);
            p.collides = false;
        }
	}
}		
