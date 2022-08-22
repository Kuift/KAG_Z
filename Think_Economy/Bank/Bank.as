// BuilderShop.as

#include "Requirements.as"
#include "ShopCommon.as"
#include "Descriptions.as"
#include "Costs.as"
#include "CheckSpam.as"
#include "GenericButtonCommon.as"
#include "TeamIconToken.as"

void onInit(CBlob@ this)
{
	InitCosts(); //read from cfg

	AddIconToken("$_buildershop_filled_bucket$", "Bucket.png", Vec2f(16, 16), 1);

	this.set_TileType("background tile", CMap::tile_wood_back);

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP
	this.set_Vec2f("shop offset", Vec2f_zero);
	this.set_Vec2f("shop menu size", Vec2f(7, 2));
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);

	// CLASS
	this.set_Vec2f("class offset", Vec2f(-6, 0));
	this.set_string("required class", "builder");

	int team_num = this.getTeamNum();

	{
		ShopItem@ s = addShopItem(this, "5 Coin Bundle", "$bundle5$", "bundle5", "Put 5 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 5);
	}

	{
		ShopItem@ s = addShopItem(this, "10 Coin Bundle", "$bundle10$", "bundle10", "Put 10 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 10);
	}

	{
		ShopItem@ s = addShopItem(this, "50 Coin Bundle", "$bundle50$", "bundle50", "Put 50 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 50);
	}

	{
		ShopItem@ s = addShopItem(this, "100 Coin Bundle", "$bundle100$", "bundle100", "Put 100 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 100);
	}

		{
		ShopItem@ s = addShopItem(this, "500 Coin Bundle", "$bundle500$", "bundle500", "Put 500 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 500);
	}

	{
		ShopItem@ s = addShopItem(this, "1000 Coin Bundle", "$bundle100$", "bundle1000", "Put 1000 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 1000);
	}

	{
		ShopItem@ s = addShopItem(this, "5000 Coin Bundle", "$bundle5000$", "bundle5000", "Put 5000 coins into a portable bundle", true);
		AddRequirement(s.requirements, "coin", "", "Coins", 5000);
	}

	{
		ShopItem@ s = addShopItem(this, "5 into 10", "$bundle10$", "bundle10", "Turn 5 coin bundles into 10 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle5", "5 Coin Bundle", 2);
	}

	{
		ShopItem@ s = addShopItem(this, "10 into 50", "$bundle50$", "bundle50", "Turn 10 coin bundles into 50 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle10", "10 Coin Bundle", 5);
	}

	{
		ShopItem@ s = addShopItem(this, "50 into 100", "$bundle100$", "bundle100", "Turn 50 coin bundles into 100 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle50", "50 Coin Bundle", 2);
	}

	{
		ShopItem@ s = addShopItem(this, "100 into 500", "$bundle500$", "bundle500", "Turn 100 coin bundles into 500 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle100", "100 Coin Bundle", 5);
	}

	{
		ShopItem@ s = addShopItem(this, "500 into 1000", "$bundle1000$", "bundle1000", "Turn 500 coin bundles into 1000 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle500", "500 Coin Bundle", 2);
	}

	{
		ShopItem@ s = addShopItem(this, "1000 into 5000", "$bundle5000$", "bundle5000", "Turn 1000 coin bundles into 5000 coin one", true);
		AddRequirement(s.requirements, "blob", "bundle1000", "1000 Coin Bundle", 5);
	}
}


void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;

	if (caller.getConfig() == this.get_string("required class"))
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

		if (!getNet().isServer()) return; /////////////////////// server only past here

		u16 caller, item;
		if (!params.saferead_netid(caller) || !params.saferead_netid(item))
		{
			return;
		}
		string name = params.read_string();
		{
			CBlob@ callerBlob = getBlobByNetworkID(caller);
			if (callerBlob is null)
			{
				return;
			}

			if (name == "filled_bucket")
			{
				CBlob@ b = server_CreateBlobNoInit("bucket");
				b.setPosition(callerBlob.getPosition());
				b.server_setTeamNum(callerBlob.getTeamNum());
				b.Tag("_start_filled");
				b.Init();
				callerBlob.server_Pickup(b);
			}
		}
	}
}
