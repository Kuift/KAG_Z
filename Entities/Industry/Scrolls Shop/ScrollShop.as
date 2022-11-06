// Builder Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "WARCosts.as";
#include "CheckSpam.as";

void onInit( CBlob@ this )
{	 
	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	
	AddIconToken("$scrollcarnage$", "ScrollCarnage.png", Vec2f(16,13), 1);
	AddIconToken("$scrolldrought$", "ScrollDrought.png", Vec2f(16,16), 1);
	AddIconToken("$scrollheal$", "ScrollHeal.png", Vec2f(16,16), 1);
	AddIconToken("$scrollmidas$", "ScrollOfMidas.png", Vec2f(16,16), 1);
	AddIconToken("$scrollreinforce$", "ScrollReinforce.png", Vec2f(16,16), 1);
	AddIconToken("$scrolltaming$", "ScrollMeteor.png", Vec2f(16,16), 1);

	//unused scrolls
	// AddIconToken("$scrollmeteor$", "ScrollMeteor.png", Vec2f(16,16), 1);
	// AddIconToken("$scrollshark$", "ScrollShark.png", Vec2f(16,16), 1);
	// AddIconToken("$scrollreturn$", "ScrollReturn.png", Vec2f(16,16), 1);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(3,2));	
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	{	 
		ShopItem@ s = addShopItem(this, "Scroll of Carnage", "$scrollcarnage$", "scarnage", "Once used, it will damage all nearby enemies.", true);
		AddRequirement(s.requirements, "blob", "mat_gold", "Gold", 200);
		AddRequirement(s.requirements, "coin", "", "Coins", 1250);
	}
	{
		ShopItem@ s = addShopItem(this, "Scroll of Drought", "$scrolldrought$", "sdrought", "Once used, it will evaporate nearby water.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}
	{
		ShopItem@ s = addShopItem(this, "Scroll of Healing", "$scrollheal$", "sheal", "Once used, it will heal nearby players.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);
	}
	{
		ShopItem@ s = addShopItem(this, "Scroll of Midas", "$scrollmidas$", "smidas", "Once used, it will turn nearby stone into gold.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 250);
	}
	{
		ShopItem@ s = addShopItem(this, "Scroll of Reinforcement", "$scrollreinforce$", "sreinforce", "Once used, it will turn nearby stone into thickstone.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 200);
	}
	{
		ShopItem@ s = addShopItem(this, "Scroll of Taming", "$scrolltaming$", "staming", "Once used, it will convert nearby zombies to be friendly.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);
	}
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{

	this.set_bool("shop available", this.isOverlapping(caller) /*&& caller.getName() == "builder"*/ );
}
								   
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound( "/ChaChing.ogg" );
	}
}
			