#define SERVER_ONLY

void onInit(CRules@ this)
{
	this.set_u32("old_rcon_time", 0);
}
void onTick(CRules@ this)
{
    u32 currentTime = getGameTime() / getTicksASecond();
    if (currentTime - this.get_u32("old_rcon_time") > 10)
    {
	    this.set_u32("old_rcon_time", currentTime);
        tcpr("ping");
    }
}  