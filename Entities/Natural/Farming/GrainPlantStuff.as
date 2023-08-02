#include "MakeSeed.as";
const int COIN_GAINED_PER_GRAIN = 5;

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

void onDie(CBlob@ this)
{
	if (getNet().isServer())
	{
		if(this !is null){
			if (this.hasTag("has grain"))
			{
				CPlayer@ killer = this.getPlayerOfRecentDamage();
				if(killer !is null){
					if(killer.getBlob().isAttached()){
						AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
						CPlayer@ holder = point.getOccupied().getPlayer();
						holder.server_setCoins(holder.getCoins()+COIN_GAINED_PER_GRAIN);
					}
					else{
						killer.server_setCoins(killer.getCoins()+COIN_GAINED_PER_GRAIN);
					}
				}
				else{
					server_DropCoins(this.getPosition(), COIN_GAINED_PER_GRAIN); //XORRandom(20) + 4);
				}
			}
			server_MakeSeed(this.getPosition(), "grain_plant", 300, 1, 4);
		}
	}
}

