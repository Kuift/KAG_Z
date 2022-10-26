void onInit(CBlob@ this)
{
	this.set_string("eat sound", "/Heart.ogg");
	this.getCurrentScript().runFlags |= Script::remove_after_this;
	//this.Tag("ignore_arrow");
	this.Tag("ignore_saw");
	this.Tag("MENDING");
}

bool canBePickedUp( CBlob@ this, CBlob@ byBlob )
{
    return true;
}
