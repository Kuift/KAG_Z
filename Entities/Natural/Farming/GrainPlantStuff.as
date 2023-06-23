#include "MakeSeed.as";
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
						holder.server_setCoins(holder.getCoins()+25);
					}
					else{
						killer.server_setCoins(killer.getCoins()+25);
					}
				}
				else{
					server_DropCoins(this.getPosition(), 25); //XORRandom(20) + 4);
				}
			}
			server_MakeSeed(this.getPosition(), "grain_plant", 300, 1, 4);
		}
	}
}

