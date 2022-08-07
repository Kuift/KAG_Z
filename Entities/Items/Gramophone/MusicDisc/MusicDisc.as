// A script by TFlippy, and used by Char. thanks TFlippy!

const string[] names =
{	"Take On Me",
	"Shinitai",
	"Hidden KAG Music",
	"Atrophy",
	"Wish I Was a Black Guy",
	"The Name's Bond",
	"Indiana Jones",
	"Baby Crush",
	"Can't Touch This",
	"Sassy Girl",
	"Your Gallant Char",
	"FELIZ JUEVES",
	"Gas Gas Gas",
	"WataOp",
	"Sensation",
	"The Sweet Escape",
	"Ghost Busters",
	"Gone To Me",
	"Kill La",
	"Rocket Girl",
	"English Sword Art Online",
	"Spider Riders",
	"Take A Hint",
	"Viva La Remix",
	"Welcome to the Club",
	"When can we do this Again",
	"Never get Naked",
	"Weeb 2",
	"Uptown Funk",
	"Weeb 3",
	"Party in the USA",
	"Despacito",
	"Minuetto",
	"Spooky Scary Skeleton",
	"blank"

};

void onInit(CBlob@ this)
{
	this.addCommandID("set");
	this.set_u8("trackID", XORRandom(names.size()-1)); // Temporary 
	
	SetTrack(this, this.get_u8("trackID"));
}

void SetTrack(CBlob@ this, u8 inIndex)
{
	if (inIndex > names.length - 1) return;

	this.set_u8("trackID", inIndex);
	this.getSprite().SetAnimation("track" + inIndex);
	this.setInventoryName("Gramophone Record (" + names[inIndex] + ")");
	
	// print("Current: " + this.getSprite().animation.name + "; Should be: " + "track" + inIndex);
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	// print("cmd");

	if (getNet().isClient())
	{
		if (cmd == this.getCommandID("set"))
		{
			// print("set");
			SetTrack(this, params.read_u8());
		}
	}
}