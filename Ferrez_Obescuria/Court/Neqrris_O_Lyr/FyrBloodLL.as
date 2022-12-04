#include "FireCommon.as";

const f32 fyrblood_range = 64.00f;
const f32 fyrblood_range2 = 256.00f;

void onInit(CBlob@ this)
{
    this.Tag("dont deactivate");
    this.Tag("fire source");
    this.Tag("fyr");
    this.getCurrentScript().tickFrequency = 45;
}

void onTick(CBlob@ this)
{
	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
    if (getNet().isServer() && this.getHealth() > 0.5f)
    {
        CBlob@[] blobs;
        if (getMap().getBlobsInRadius(this.getPosition(), fyrblood_range, @blobs))
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
	else if(this.hasTag("PhaseFour"))
	{
	if (getNet().isServer() && this.getHealth() > 0.5f)
    {
        CBlob@[] blobs;
        if (getMap().getBlobsInRadius(this.getPosition(), fyrblood_range2, @blobs))
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
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
    return blob.getShape().isStatic();
}