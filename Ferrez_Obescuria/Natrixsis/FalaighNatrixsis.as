// Lantern script
#define SERVER_ONLY;
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";

const int TELE_SPAWNING_FREQUENCY = 240;
const int TELE_SPAWNING_FREQUENCY_A = 210; 
const int TELE_SPAWNING_FREQUENCY_B = 180;  

const f32 MAX_RANGE = 128.00f;
const f32 MAX_RANGE_A = 192.00f;
const f32 MAX_RANGE_B = 256.0f;
const f32 MIN_RANGE = 32.0f;
void onInit(CBlob@ this)
{

	this.set_u32("last tele spawned", 0 );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("tep");
}

void onTick(CBlob@ this)
{

	if(this.hasTag("PhaseOne") && !this.hasTag("PhaseTwo"))
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
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(35, -10.0f));
		break;
		}
		
		else if (playerBlob !is null && !facingleft)
		{
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-35, -10.0f));
		break;
		}
		
	}
	this.set_u32("last tele spawned", getGameTime());
	}
	}
	
	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if ((this.getHealth()>0.5))
	{
	u32 lastteleSpawningTime = this.get_u32("last tele spawned");
	f32 spawning_frequency = TELE_SPAWNING_FREQUENCY_A;
	int diff = getGameTime() - (lastteleSpawningTime + spawning_frequency);
	

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}
		const bool facingleft = playerBlob.isFacingLeft();
		

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGE_A){continue;}

		//if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}
		
		if (playerBlob !is null && facingleft)
		{
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(35, -10.0f));
		break;
		}
		
		else if (playerBlob !is null && !facingleft)
		{
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-35, -10.0f));
		break;
		}
		
	}
	this.set_u32("last tele spawned", getGameTime());
	}
	}
	
	if(this.hasTag("PhaseThree"))
	{
	if ((this.getHealth()>0.5))
	{
	u32 lastteleSpawningTime = this.get_u32("last tele spawned");
	f32 spawning_frequency = TELE_SPAWNING_FREQUENCY_B;
	int diff = getGameTime() - (lastteleSpawningTime + spawning_frequency);
	

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}
		const bool facingleft = playerBlob.isFacingLeft();
		

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGE_B){continue;}

		//if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}
		
		if (playerBlob !is null && facingleft)
		{
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(35, -10.0f));
		break;
		}
		
		else if (playerBlob !is null && !facingleft)
		{
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(50, -10.0f));
		server_CreateBlob("barrier", -1, playerBlob.getPosition() + Vec2f(-35, -10.0f));
		break;
		}
		
	}
	this.set_u32("last tele spawned", getGameTime());
	}
	}
	


}


