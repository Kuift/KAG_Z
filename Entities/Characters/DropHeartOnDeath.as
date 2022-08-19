
//random heart on death (default is 100% of the time for consistency + to reward murder)

#define SERVER_ONLY

const f32 probability = 1.0f; //between 0 and 1

void dropHeart(CBlob@ this)
{
	if (!this.hasTag("dropped heart")) //double check
	{
		CPlayer@ killer = this.getPlayerOfRecentDamage();
		CPlayer@ myplayer = this.getDamageOwnerPlayer();

		if (killer is null || ((myplayer !is null) && killer.getUsername() == myplayer.getUsername())) { return; }

		this.Tag("dropped heart");

		if ((XORRandom(1024) / 1024.0f) < probability)
		{
			CBlob@ heart = server_CreateBlob("heart", -1, this.getPosition());

			if (heart !is null)
			{
				Vec2f vel(XORRandom(2) == 0 ? -2.0 : 2.0f, -5.0f);
				heart.setVelocity(vel);
			}
			/*if (this.getName() == "onestarbuilder")
			{
			CBlob@ osb = server_CreateBlob("onestarbuilderuniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "twostarbuilder")
			{
			CBlob@ tsb = server_CreateBlob("twostarbuilderuniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "threestarbuilder")
			{
			CBlob@ thsb = server_CreateBlob("threestarbuilderuniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "onestararcher")
			{
			CBlob@ osa = server_CreateBlob("onestararcheruniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "twostararcher")
			{
			CBlob@ tsa = server_CreateBlob("twostararcheruniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "threestararcher")
			{
			CBlob@ thsa = server_CreateBlob("threestararcheruniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "onestarknight")
			{
			CBlob@ osk = server_CreateBlob("onestarknightuniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "twostarknight")
			{
			CBlob@ tsk = server_CreateBlob("twostarknightuniform", -1, this.getPosition()); 
			}
			else if (this.getName() == "threestarknight")
			{
			CBlob@ thsk = server_CreateBlob("threestarknightuniform", -1, this.getPosition()); 
			}*/
		}
	}
}

void onDie(CBlob@ this)
{
	if (this.hasTag("switch class") || this.hasTag("dropped heart") || this.hasBlob("food", 1)) { return; }    //don't make a heart on change class, or if this has already run before or if had bread

	dropHeart(this);
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
