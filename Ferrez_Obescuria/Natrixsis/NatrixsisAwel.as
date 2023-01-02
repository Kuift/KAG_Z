const int FIRE_FREQUENCY = 50;
const f32 BOLT_SPEED = 1.5f;
const f32 max_range = 128.00f;

const int FIRE_FREQUENCY2 = 21;
const f32 BOLT_SPEED2 = 3.0f;
const f32 BOLT_SPEED3 = 7.0f;
const f32 max_range2 = 166.00f;
void onInit(CBlob@ this)
{
	this.set_u32("last bolt fire", 0);
}


	void onTick(CBlob@ this)
{
	if(this.hasTag("PhaseOne") && !this.hasTag("PhaseTwo"))
	{
	if (getNet().isServer() && (this.getHealth()>0.5))
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
				if (this.getMap().getBlobsInRadius(this.getPosition(), max_range, @targets))
				{
					for (int i = 0; i < targets.length; i++)
					{
						CBlob@ b = targets[i];
						if (b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("player"))
						{
							targetID = b.getNetworkID();
						
					
				
			

			lastFireTime = gametime;
			this.set_u32("last bolt fire", lastFireTime);
				
			CBlob@ bolt = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED2 : 0.1f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			CBlob@ bolt2 = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(0.0f, -3.5f * this.getRadius()));
			if (bolt2 !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt2.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED2 : 0.1f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt2.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if (getNet().isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY2);

		if (diff > 0)
		{
			Vec2f pos = this.getPosition();
			Vec2f aim = this.getAimPos();

			u16 targetID = 0xffff;
			CMap@ map = this.getMap();
			if (map !is null)
			{
				CBlob@[] targets;
				if (this.getMap().getBlobsInRadius(this.getPosition(), max_range2, @targets))
				{
					for (int i = 0; i < targets.length; i++)
					{
						CBlob@ b = targets[i];
						if (b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("player"))
						{
							targetID = b.getNetworkID();
						
					
				
			

			lastFireTime = gametime;
			this.set_u32("last bolt fire", lastFireTime);

			CBlob@ bolt = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED2 : 0.1f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			CBlob@ bolt2 = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(0.0f, -3.5f * this.getRadius()));
			if (bolt2 !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt2.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED2 : 0.1f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt2.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
	
	if(this.hasTag("PhaseThree"))
	{
	if (getNet().isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY2);

		if (diff > 0)
		{
			Vec2f pos = this.getPosition();
			Vec2f aim = this.getAimPos();

			u16 targetID = 0xffff;
			CMap@ map = this.getMap();
			if (map !is null)
			{
				CBlob@[] targets;
				if (this.getMap().getBlobsInRadius(this.getPosition(), max_range2, @targets))
				{
					for (int i = 0; i < targets.length; i++)
					{
						CBlob@ b = targets[i];
						if (b !is null && b.getTeamNum() != this.getTeamNum() && b.hasTag("player"))
						{
							targetID = b.getNetworkID();
						
					
				
			

			lastFireTime = gametime;
			this.set_u32("last bolt fire", lastFireTime);

			CBlob@ bolt = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(3.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED3 : 0.1f * BOLT_SPEED3));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			CBlob@ bolt2 = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(0.0f, -3.5f * this.getRadius()));
			if (bolt2 !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt2.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED3 : 0.1f * BOLT_SPEED3));

				if (targetID != 0xffff)
				{
					bolt2.set_u16("target", targetID);
				}
			}
			CBlob@ bolt3 = server_CreateBlob("awel", this.getTeamNum(), pos + Vec2f(3.0f, -0.5f * this.getRadius()));
			if (bolt3 !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt3.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED3 : 0.1f * BOLT_SPEED3));

				if (targetID != 0xffff)
				{
					bolt3.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
}
