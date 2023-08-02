const int FIRE_FREQUENCY = 25;
const f32 BOLT_SPEED = 18.0f;

void onInit(CBlob@ this)
{
	this.set_u32("last bolt fire", 0);
	this.getCurrentScript().tickFrequency = 2;
}

void onTick(CBlob@ this)
{
	if (getNet().isServer())
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY);

		if (diff > 0)
		{
			Vec2f pos = this.getPosition();
			Vec2f aim = this.getAimPos();

			u16 targetID = 0xffff;
			CMap@ map = this.getMap();
			if (map !is null)
			{
				CBlob@[] targets;
				if (map.getBlobsInRadius(aim, 64.0f, @targets))
				{
					for (int i = 0; i < targets.length; i++)
					{
						CBlob@ b = targets[i];
						if (b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("flesh"))
						{
							targetID = b.getNetworkID();
						}
					}
				}
			}

			lastFireTime = gametime;
			this.set_u32("last bolt fire", lastFireTime);

			CBlob@ bolt = server_CreateBlob("bloodhold", this.getTeamNum(), pos + Vec2f(0.0f, -0.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY ? BOLT_SPEED : 0.0f * BOLT_SPEED));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
		}
	}
}
