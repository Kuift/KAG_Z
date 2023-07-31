#include "Hitters.as"

const float DAMAGE = 0.5f;
const float HIT_PER_SECOND = 6.0f;

void onInit(CBlob@ this)
{
	this.getCurrentScript().tickFrequency = HIT_PER_SECOND;
    this.set_bool("attached", false);
    this.set_u32("oldTimeSecs", 0);
}

void onTick(CBlob@ this )
{
    if((getGameTime()/30.0f)-this.get_u32("oldTimeSecs")/1.0f > 1/HIT_PER_SECOND)
    {
        this.set_u32("oldTimeSecs", getGameTime()/30);
        if (this.get_bool("attached"))
        {
            CBlob@ parent = getBlobByNetworkID(this.get_netid("attached_blob_id"));
            if (parent !is null)
            {
                this.server_Hit(parent, parent.getPosition(), Vec2f(0.0f,0.0f), (DAMAGE + XORRandom(DAMAGE)), Hitters::drown);
            }
            else{
                this.server_Die();
            }
        }
    }
}
void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal )
{
	if (blob !is null /*&& doesCollideWithBlob(this, blob)*/ && !this.hasTag("collided") && blob.hasTag("player")  && this.get_bool("attached") == false)
	{
        this.server_SetTimeToDie(20.0f);
		attachAttack(this, blob);
		//this.server_Die();
	}
}

void attachAttack(CBlob@ this, CBlob@ targetBlob)
{
    targetBlob.set_u16("attached_slugs", targetBlob.get_u16("attached_slugs") + 1);
    u16 numberOfAttachedSlugs = targetBlob.get_u16("attached_slugs"); 
    this.set_netid("attached_blob_id", targetBlob.getNetworkID());

    AttachmentPoint@ attachment = targetBlob.getAttachments().AddAttachmentPoint("slug_attach_" + numberOfAttachedSlugs, true);
    
    Vec2f deltaPos = this.getPosition() - targetBlob.getPosition();
    attachment.offset = Vec2f(deltaPos.x/5.0f, deltaPos.y); // put the attachment where the bullet hit
    
    this.setVelocity(Vec2f(0.0f, 0.0f));
    
    bool attachSuccess = targetBlob.server_AttachTo(this, attachment);
    this.set_bool("attached", attachSuccess);

    //print("attached to " + targetBlob.getName() + " : " + numberOfAttachedSlugs + " bool : " + attachSuccess);
}