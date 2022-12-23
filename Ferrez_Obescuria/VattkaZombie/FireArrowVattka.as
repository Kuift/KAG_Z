const int FIRE_FREQUENCY = 13;
const f32 BOLT_SPEED = 19.0f;
const f32 max_range = 64.00f;
void onInit(CBlob@ this)
{
	this.set_u32("last bolt fire", 0);
}

void onTick(CBlob@ this)
{
	if (getNet().isServer()&& (this.getHealth()>0.1))
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
				for(int i = 0; i < getPlayerCount(); ++i){
                    CPlayer@ player = getPlayer(i);
                    if(player !is null){
						CBlob@ playerBlob = p.getBlob();
						if (playerBlob !is null)
						{
							if ((this.getPosition() - playerBlob.getPosition()).getLength() < max_range)
							{
								if(!this.getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition()))
								{
									targetID = playerBlob.getNetworkID();
									lastFireTime = gametime;
									this.set_u32("last bolt fire", lastFireTime);

									CBlob@ bolt = server_CreateBlob("arrow", this.getTeamNum(), pos + Vec2f(0.0f, -0.5f * this.getRadius()));
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
							}
						}
                    }
                }
			} //fix
		}
	}
}
