// Lantern script
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";
const f32 max_range = 256.00f;
void onInit(CBlob@ this)
{
	this.Tag("dont deactivate");
	this.Tag("fire source");
	this.Tag("fyr");
	this.getCurrentScript().tickFrequency = 5;
}

void onTick(CBlob@ this)
{
CBlob@[] blobs;

    if (getNet().isServer())
    {
    if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @blobs) && this.hasTag("fyr"))
    {
        for (int i = 0; i < blobs.length; i++)
        {
            CBlob@ blob = blobs[i];

            if (!this.getMap().rayCastSolidNoBlobs(blob.getPosition(), this.getPosition()))
            {
                f32 dist = (blob.getPosition() - this.getPosition()).getLength();
                f32 factor = 1.00f - Maths::Pow(dist / max_range, 2);

                 //SetKnocked(blob, 75 * factor);

                if (blob is getLocalPlayerBlob() && this.getTeamNum() != blob.getTeamNum())
                {
                    Vec2f delta = this.getPosition() - blob.getPosition();

        Vec2f lastBurnPos = this.get_Vec2f("last burn pos");
        getMap().server_setFireWorldspace(lastBurnPos, false);
        getMap().server_setFireWorldspace(blob.getPosition(), true);
        this.set_Vec2f("last burn pos", blob.getPosition());

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
