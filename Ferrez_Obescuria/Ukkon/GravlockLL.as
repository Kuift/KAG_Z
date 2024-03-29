// Lantern script
#include "Knocked.as";
#include "Hitters.as";
const f32 max_range = 256.00f;
const float field_force = 0.50;
const float mass = 1.0;

const float first_radius = 64.0;
const float second_radius = 220.0;
void onInit(CBlob@ this)
{

	this.Tag("dont deactivate");


	this.getCurrentScript().tickFrequency = 3;
	this.Tag("ner");
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
            CBlob@ blob = blobs[i];
            if ( blob.getTeamNum() == this.getTeamNum() ) continue;

            Vec2f delta = blob.getPosition() - this.getPosition();

            Vec2f force = -delta;
            force.Normalize();
            force *= (field_force * mass * blob.getMass() * (delta.Length() / second_radius));

            blob.AddForce(force);
			
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
