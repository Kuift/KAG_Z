
#define SERVER_ONLY

const string custom_amount_prop = "gold building amount";

void onDie(CBlob@ this)
{
	int drop_amount = this.exists(custom_amount_prop) ?
			this.get_s32(custom_amount_prop) :
			50;
	if (drop_amount == 0) return;
    if (drop_amount != 0) return; //prevent gold from spawning
}
