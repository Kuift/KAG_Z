// Lantern script
#define SERVER_ONLY;
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";

const int SLATE_SPAWNING_FREQUENCY_PHASE_1 = 120; //4 secs
const int SLATE_SPAWNING_FREQUENCY_PHASE_2 = 60; //2 secs
const f32 MAX_RANGE = 128.00f;
const f32 MIN_RANGE = 16.0f;
void onInit(CBlob@ this)
{

	this.set_u32("last slate spawned", 0 );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("tep");
}

void onTick(CBlob@ this)
{
	u32 lastSlateSpawningTime = this.get_u32("last slate spawned");
	f32 spawning_frequency = this.getHealth() > 15.0f ? SLATE_SPAWNING_FREQUENCY_PHASE_1 : SLATE_SPAWNING_FREQUENCY_PHASE_2;
	int diff = getGameTime() - (lastSlateSpawningTime + spawning_frequency);

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGE){continue;}

		if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		server_CreateBlob("slate", -1, playerBlob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
		//put a break here if we want brytir to target 1 player instead of all player within range
	}
	this.set_u32("last slate spawned", getGameTime());
}
