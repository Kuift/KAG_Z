// Lantern script
#define SERVER_ONLY;
#include "Knocked.as";
#include "Hitters_mod.as";
#include "FireCommon.as";

const int TELE_SPAWNING_FREQUENCY = 240; //6 secs

const f32 MAX_RANGE = 10028.00f;
const f32 MIN_RANGE = 128.0f;
void onInit(CBlob@ this)
{

	this.set_u32("last tele spawned", 0 );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("tep");
}

void onTick(CBlob@ this)
{

	if ((this.getHealth()>0.5))
	{
	u32 lastteleSpawningTime = this.get_u32("last tele spawned");
	f32 spawning_frequency = TELE_SPAWNING_FREQUENCY;
	int diff = getGameTime() - (lastteleSpawningTime + spawning_frequency);
	

	if (diff <= 0) {return;}
	

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}
		const bool facingleft = playerBlob.isFacingLeft();
		

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGE){continue;}

		//if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}
		
		if (playerBlob !is null && facingleft)
		{
		server_CreateBlob("A1", -1, playerBlob.getPosition() + Vec2f(35, -5.0f));
		break;
		}
		
		else if (playerBlob !is null && !facingleft)
		{
		server_CreateBlob("A1", -1, playerBlob.getPosition() + Vec2f(-35, -5.0f));
		break;
		}
		
	}
	this.set_u32("last tele spawned", getGameTime());
	}
	


}


