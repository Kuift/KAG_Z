#include "FireCommon.as";

const f32 fyrfyrnigh_range = 256.00f;

void onInit(CBlob@ this)
{
    this.Tag("dont deactivate");
    this.Tag("fire source");
    this.Tag("fyr");
    this.getCurrentScript().tickFrequency = 45;
	this.server_SetTimeToDie(12);
}

void onTick(CBlob@ this)
{

    if (getNet().isServer() && this.getHealth() > 0.5f)
    {
        CBlob@[] blobs;
        if (getMap().getBlobsInRadius(this.getPosition(), fyrfyrnigh_range, @blobs))
        {
            for (int i = 0; i < blobs.length; i++)
            {
                CBlob@ blob = blobs[i];

                if (!getMap().rayCastSolidNoBlobs(blob.getPosition(), this.getPosition()))
                {
                    if (blob.getPlayer() !is null && this.getTeamNum() != blob.getTeamNum())
                    {
                        Vec2f delta = this.getPosition() - blob.getPosition();

                        Vec2f lastBurnPos = this.exists("last burn pos") ? this.get_Vec2f("last burn pos") : blob.getPosition();
                        getMap().server_setFireWorldspace(lastBurnPos, false);
                        getMap().server_setFireWorldspace(blob.getPosition(), true);
                        this.set_Vec2f("last burn pos", blob.getOldPosition());
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

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{	

	if (customData == Hitters::notnormalfire)
	{
		damage*= 0.0;
	}
	return damage;
	}
	
	bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return false;
}
