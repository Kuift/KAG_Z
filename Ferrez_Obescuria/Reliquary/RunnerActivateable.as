void onInit(CBlob@ this)
{
	//these don't actually use it, they take the controls away
	this.push("names to activate", "lantern");
	this.push("names to activate", "blindr");
	this.push("names to activate", "fyr");
	this.push("names to activate", "nerit");
	this.push("names to activate", "crate");
	this.getCurrentScript().runFlags |= Script::remove_after_this;
}
