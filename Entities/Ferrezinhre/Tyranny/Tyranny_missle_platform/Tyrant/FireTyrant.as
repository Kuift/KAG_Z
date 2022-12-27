const int FIRE_FREQUENCY = 13;
const f32 BOLT_SPEED = 19.0f;
const f32 max_range = 128.00f;
void onInit(CBlob@ this)
{
	this.set_u32("last bolt fire", 0);
	this.getCurrentScript().tickFrequency = 5;
}

void onTick(CBlob@ this)
{
	if (isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		int diff = getGameTime() - (lastFireTime + FIRE_FREQUENCY);

		if (diff <= 0) {return;}

		CMap@ map = this.getMap();
		if (map is null) {return;}

		//Check for all blob nearby, and we consider all thing that aren't part of our team and have the flesh and zombieportalz tag as potential target
		CBlob@[] targets;
		if (!this.getMap().getBlobsInRadius(this.getPosition(), max_range, @targets)) {return;}

		for (int i = 0; i < targets.length; i++)
		{
			CBlob@ targetBlob = targets[i];
			if ((targetBlob !is null && targetBlob.getTeamNum() != this.getTeamNum() && (targetBlob.hasTag("flesh") || targetBlob.hasTag("ZombiePortalz"))) && this.getTickSinceCreated() > 5 )
			{
				lastFireTime = getGameTime();
				this.set_u32("last bolt fire", lastFireTime);
				shoot_ibrak(this, targetBlob);
				break;
			}
		}
	}
}

void shoot_ibrak(CBlob@ this, CBlob@ targetBlob)
{
	u16 targetID = 0xffff;
	targetID = targetBlob.getNetworkID();
	Vec2f pos = this.getPosition();
	Vec2f aim = this.getAimPos();
	int diff = getGameTime() - (this.get_u32("last bolt fire") + FIRE_FREQUENCY);
	CBlob@ bolt = server_CreateBlob("ibrak", this.getTeamNum(), pos + Vec2f(0.0f, -0.5f * this.getRadius()));
	if (bolt !is null)
	{
		Vec2f norm = aim - pos;
		norm.Normalize();
		bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY ? BOLT_SPEED : 0.1f * BOLT_SPEED));

		if (targetID != 0xffff)
		{
			bolt.set_u16("target", targetID);
		}
	}
}