// Knight Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "CTFShopCommon.as";
#include "Descriptions.as";

s32 cost_bomb = 25;
s32 cost_waterbomb = 30;
s32 cost_keg = 120;
s32 cost_mine = 60;

void onInit(CBlob@ this)
{
	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	//load config
	if (getRules().exists("ctf_costs_config"))
	{
		cost_config_file = getRules().get_string("ctf_costs_config");
	}

	ConfigFile cfg = ConfigFile();
	cfg.loadFile(cost_config_file);

	cost_bomb = cfg.read_s32("cost_bomb_plain", cost_bomb);
	cost_waterbomb = cfg.read_s32("cost_bomb_water", cost_waterbomb);
	cost_mine = cfg.read_s32("cost_mine", cost_mine);
	cost_keg = cfg.read_s32("cost_keg", cost_keg);

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(3, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "Polearm");

	{
		ShopItem@ s = addShopItem(this, "Bomb", "$bomb$", "mat_bombs", "Blow things up!", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_bomb);
	}
	{
		ShopItem@ s = addShopItem(this, "Water Bomb", "$waterbomb$", "mat_waterbombs", "Can extinguish fires and stun enemies.", true);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_waterbomb);
	}
	{
		ShopItem@ s = addShopItem(this, "Mine", "$mine$", "mine", Descriptions::mine, false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_mine);
	}
	{
		ShopItem@ s = addShopItem(this, "Keg", "$keg$", "keg", "Highly explosive powder keg.", false);
		AddRequirement(s.requirements, "coin", "", "Coins", cost_keg);
	}
	{
		ShopItem@ s = addShopItem(this, "twostarpolearmuniform", "$twostarpolearmuniform$", "twostarpolearmuniform", "Upgraded Polearm class", false);
		AddRequirement(s.requirements, "blob", "onestarpolearmuniform", "onestarpolearmuniform", 2);
	}
	{
		ShopItem@ s = addShopItem(this, "threestarpolearmuniform", "$threestarpolearmuniform$", "threestarpolearmuniform", "Upgraded Polearm class", false);
		AddRequirement(s.requirements, "blob", "twostarpolearmuniform", "twostarpolearmuniform", 2);
	}
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if(caller.getConfig() == this.get_string("required class"))
	{
		this.set_Vec2f("shop offset", Vec2f_zero);
	}
	else
	{
		this.set_Vec2f("shop offset", Vec2f(6, 0));
	}
	this.set_bool("shop available", this.isOverlapping(caller));
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound("/ChaChing.ogg");
	}
}
