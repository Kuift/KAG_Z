const int FIRE_FREQUENCY = 52; // bigger increase the delay
const f32 BOLT_SPEED = 19.0f;
const f32 MAX_RANGE = 128.00f;
const f32 MIN_RANGE = 64.00f;
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

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGE){continue;}

		if(map.rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		targetID = playerBlob.getNetworkID();
		lastFireTime = gametime;
		this.set_u32("last bolt fire", lastFireTime);

		//create bolt
		CBlob@ bolt = server_CreateBlob("arrow", this.getTeamNum(), pos + Vec2f(0.0f, -0.5f * this.getRadius()));

		if (bolt is null) {continue;}
		Vec2f norm = aim - pos;
		norm.Normalize();
		Vec2f velocityVector = norm * (diff <= FIRE_FREQUENCY ? BOLT_SPEED : 0.1f * BOLT_SPEED);
		float bias = XORRandom(30)/2; // make it easier, there's a 15 degree mistake range
		bolt.setVelocity(velocityVector.RotateBy(-bias));

		if (targetID != 0xffff)
		{
			bolt.set_u16("target", targetID);
		}
	}
}
