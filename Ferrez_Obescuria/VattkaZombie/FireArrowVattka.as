const int FIRE_FREQUENCY = 13;
const f32 BOLT_SPEED = 19.0f;
const f32 max_range = 64.00f;
void onInit(CBlob@ this)
{
	this.set_u32("last bolt fire", 0);
}

void onTick(CBlob@ this)
{
	if (!isServer() && !(this.getHealth() > 0.1)) {return;}
	u32 lastFireTime = this.get_u32("last bolt fire");
	const u32 gametime = getGameTime();
	int diff = gametime - (lastFireTime + FIRE_FREQUENCY);

	if (diff <= 0) {return;}
	Vec2f pos = this.getPosition();
	Vec2f aim = this.getAimPos();

	u16 targetID = 0xffff;
	CMap@ map = this.getMap();
	if (map is null){return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}

		if ((this.getPosition() - playerBlob.getPosition()).getLength() > max_range){continue;}

		if(map.rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		targetID = playerBlob.getNetworkID();
		lastFireTime = gametime;
		this.set_u32("last bolt fire", lastFireTime);

		//create bolt
		CBlob@ bolt = server_CreateBlob("arrow", this.getTeamNum(), pos + Vec2f(0.0f, -0.5f * this.getRadius()));

		if (bolt is null) {continue;}
		Vec2f norm = aim - pos;
		norm.Normalize();
		bolt.setVelocity(norm * (diff <= FIRE_FREQUENCY ? BOLT_SPEED : 0.1f * BOLT_SPEED));

		if (targetID != 0xffff)
		{
			bolt.set_u16("target", targetID);
		}
	}
}
