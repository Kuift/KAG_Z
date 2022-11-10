#include "MakeSeed.as";
bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

void onDie(CBlob@ this)
{
	if (getNet().isServer())
	{
		if (this.hasTag("has grain"))
		{
			CPlayer@ killer = this.getPlayerOfRecentDamage();
			if(killer !is null){
				killer.server_setCoins(killer.getCoins()+25);
			}
			else{
				server_DropCoins(this.getPosition(), 25); //XORRandom(20) + 4);
			}
		}
		server_MakeSeed(this.getPosition(), "grain_plant", 300, 1, 4);
	}
}

