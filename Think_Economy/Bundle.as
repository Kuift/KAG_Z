//coin bundle script

void onInit( CBlob@ this )
{
	this.addCommandID( "transfer" );
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton( 26, Vec2f_zero, this, 	this.getCommandID("transfer"), "Get coins", params );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("transfer"))
	{
		bool hit = false;
		u16 caller_id = params.read_u16();
		CBlob@ caller = getBlobByNetworkID( caller_id );
		
		u16 value = 0; //analyzing value of the bundle
		if( this.getName() == "bundle5" )
		{
			value = 5;
		}
		if( this.getName() == "bundle10")
		{
			value = 10;
		}
		if( this.getName() == "bundle50")
		{
			value = 50;
		}
		if( this.getName() == "bundle100")
		{
			value = 100;
		}
		if( this.getName() == "bundle500")
		{
			value = 500;
		}
		if( this.getName() == "bundle1000")
		{
			value = 1000;
		}
		if( this.getName() == "bundle5000")
		{
			value = 5000;
		}

		if ( caller !is null )
		{
			if (getNet().isServer() )
			{
				if (caller !is null )
				{
					caller.getPlayer().server_setCoins(caller.getPlayer().getCoins()+value);
					hit = true;
				}
				if(hit)
				{
					Sound::Play( "snes_coin.ogg", this.getPosition(), 8.0, 0.8 );
					this.server_Die();
				
				}
   			}
		}
	}
}