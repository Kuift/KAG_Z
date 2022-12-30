const int FIRE_FREQUENCY = 50;
const f32 BOLT_SPEED = 19.0f;
const f32 max_range = 264.00f;

const int FIRE_FREQUENCY2 = 21;
const int FIRE_FREQUENCY3 = 13;
const f32 BOLT_SPEED2 = 24.0f;
const f32 max_range2 = 375.00f;
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

			CBlob@ bolt = server_CreateBlob("toranoi", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY ? BOLT_SPEED : 1.0f * BOLT_SPEED));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
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

			CBlob@ bolt = server_CreateBlob("toranoi", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY2 ? BOLT_SPEED2 : 1.0f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
	
	if(this.hasTag("PhaseThree") && !this.hasTag("PhaseFour"))
	{
	if (getNet().isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY3);

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

			CBlob@ bolt = server_CreateBlob("greatertoranoi", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY3 ? BOLT_SPEED2 : 1.0f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
	
	
	if(this.hasTag("PhaseFour"))
	{
	if (getNet().isServer() && (this.getHealth()>0.5))
	{
		u32 lastFireTime = this.get_u32("last bolt fire");
		const u32 gametime = getGameTime();
		int diff = gametime - (lastFireTime + FIRE_FREQUENCY3);

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

			CBlob@ bolt = server_CreateBlob("greatertoranoi", this.getTeamNum(), pos + Vec2f(0.0f, -1.5f * this.getRadius()));
			if (bolt !is null)
			{
				Vec2f norm = aim - pos;
				norm.Normalize();
				bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY3 ? BOLT_SPEED2 : 1.0f * BOLT_SPEED2));

				if (targetID != 0xffff)
				{
					bolt.set_u16("target", targetID);
				}
			}
			}}}} //fix
		}
	}
	}
}
