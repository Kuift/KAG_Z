const int SHOOT_FREQUENCY = 4;
const f32 MIGHT_SPEED = 24.0f;
const f32 max_range = 256.00f;
const f32 min_range = 64.00f;
void onInit(CBlob@ this)
{
	this.set_u32("last might fire", 0);
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
}

void onTick(CBlob@ this)
{
	if (getNet().isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last might fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + SHOOT_FREQUENCY);

		if (diff > 0)
		{
			Vec2f pos = this.getPosition();
			Vec2f aim = this.getAimPos();

			u16 targetID = 0xffff;
			CMap@ map = this.getMap();
			if (map !is null)
			{
				CBlob@[] targets;
				if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @targets))
				{
					for (int i = 0; i < targets.length; i++)
					{
					
						CBlob@ b = targets[i];
						if (!this.getMap().rayCastSolidNoBlobs(b.getPosition(), this.getPosition()))
					{
						if (b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("zombie") || b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("player") || b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("fanatic"))
						{
							targetID = b.getNetworkID();
						
					
				
			

			lastFireTime = gametime;
			this.set_u32("last might fire", lastFireTime);

			CBlob@ might = server_CreateBlob("might", this.getTeamNum(), pos + Vec2f(0.0f, -10.0f));
			if (might !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				might.setVelocity(norm * (diff <= SHOOT_FREQUENCY ? MIGHT_SPEED : 0.1f * MIGHT_SPEED));

				if (targetID != 0xffff)
				{
					might.set_u16("target", targetID);
				}
			}
			}}}}} //fix
		}
	}
}
