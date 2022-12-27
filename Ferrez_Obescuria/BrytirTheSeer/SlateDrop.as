// Lantern script
#define SERVER_ONLY;
#include "Knocked.as";
#include "Hitters.as";
#include "FireCommon.as";

<<<<<<< HEAD
const int SLATE_SPAWNING_FREQUENCY_PHASE_1 = 120; //4 secs
const int SLATE_SPAWNING_FREQUENCY_PHASE_2 = 60; //2 secs
const f32 MAX_RANGE = 128.00f;
=======
const int SLATE_SPAWNING_FREQUENCY_PHASE_1 = 180; //6 secs
const int SLATE_SPAWNING_FREQUENCY_PHASE_2 = 120; //4 secs
const int SLATE_SPAWNING_FREQUENCY_PHASE_3 = 60; //4 secs
const f32 MAX_RANGEA = 128.00f;
const f32 MAX_RANGEB = 244.00f;
const f32 MAX_RANGEC = 328.00f;
>>>>>>> 03fe2c3d227cf835d89bff91e7d099ff557a7c2d
const f32 MIN_RANGE = 16.0f;
void onInit(CBlob@ this)
{

	this.set_u32("last slate spawned", 0 );
	this.getCurrentScript().tickFrequency = 5;
	this.Tag("tep");
}

void onTick(CBlob@ this)
{
	if(this.hasTag("PhaseOne") && !this.hasTag("PhaseTwo"))
	{
	if ((this.getHealth()>0.5))
	{
	u32 lastSlateSpawningTime = this.get_u32("last slate spawned");
	f32 spawning_frequency = SLATE_SPAWNING_FREQUENCY_PHASE_1;
	int diff = getGameTime() - (lastSlateSpawningTime + spawning_frequency);

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGEA){continue;}

		if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		server_CreateBlob("slate", -1, playerBlob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
		//put a break here if we want brytir to target 1 player instead of all player within range
	}
	this.set_u32("last slate spawned", getGameTime());
	}}
	
	if(this.hasTag("PhaseTwo") && !this.hasTag("PhaseThree"))
	{
	if ((this.getHealth()>0.5))
	{
	u32 lastSlateSpawningTime = this.get_u32("last slate spawned");
	f32 spawning_frequency = SLATE_SPAWNING_FREQUENCY_PHASE_2;
	int diff = getGameTime() - (lastSlateSpawningTime + spawning_frequency);

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGEB){continue;}

		if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		server_CreateBlob("slate", -1, playerBlob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
		//put a break here if we want brytir to target 1 player instead of all player within range
	}
	this.set_u32("last slate spawned", getGameTime());
	}}
	
	if(this.hasTag("PhaseThree"))
	{
	if ((this.getHealth()>0.5))
	{
	u32 lastSlateSpawningTime = this.get_u32("last slate spawned");
	f32 spawning_frequency = SLATE_SPAWNING_FREQUENCY_PHASE_3;
	int diff = getGameTime() - (lastSlateSpawningTime + spawning_frequency);

	if (diff <= 0) {return;}

	for(int i = 0; i < getPlayerCount(); ++i){
		CPlayer@ player = getPlayer(i);
		if(player is null){continue;}

		CBlob@ playerBlob = player.getBlob();
		if (playerBlob is null) {continue;}

		float distanceBetweenPlayerAndThis = (this.getPosition() - playerBlob.getPosition()).getLength();
		if (distanceBetweenPlayerAndThis < MIN_RANGE || distanceBetweenPlayerAndThis > MAX_RANGEC){continue;}

		if(getMap().rayCastSolidNoBlobs(playerBlob.getPosition(), this.getPosition())){continue;}

		server_CreateBlob("slate", -1, playerBlob.getPosition() + Vec2f(0 , -40.0f - XORRandom(80)));
		//put a break here if we want brytir to target 1 player instead of all player within range
	}
	this.set_u32("last slate spawned", getGameTime());
	}}
}
