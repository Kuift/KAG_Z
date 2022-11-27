//brain

#define SERVER_ONLY

#include "PressOldKeys.as";
#include "AnimalConsts.as";
#include "BrainCommon.as"

namespace AttackType
{
	enum type
	{
	attack_fire = 0,
	attack_manical,
	attack_rest
	};
};

void onInit(CBrain@ this)
{
	CBlob @blob = this.getBlob();
	blob.set_u8(delay_property , 10 + XORRandom(10));
	blob.set_u8(state_property, MODE_TARGET);

	if (!blob.exists(terr_rad_property))
	{
		blob.set_f32(terr_rad_property, 64.0f);
	}

	if (!blob.exists(target_searchrad_property))
	{
		blob.set_f32(target_searchrad_property, 340.0f);
	}

	if (!blob.exists(personality_property))
	{
		blob.set_u8(personality_property, 0x1);
	}

	if (!blob.exists(target_lose_random))
	{
		blob.set_u8(target_lose_random, 12);
	}

	if (!blob.exists("random move freq"))
	{
		blob.set_u8("random move freq", 2);
	}

	this.getCurrentScript().removeIfTag	= "dead";
	this.getCurrentScript().runFlags |= Script::tick_blob_in_proximity;
	this.getCurrentScript().runFlags |= Script::tick_not_attached;
	//this.getCurrentScript().runProximityTag = "player";
	//this.getCurrentScript().runProximityRadius = 488.0f;
	//this.getCurrentScript().tickFrequency = 1; // cant limit this, needs to press keys each frame

	Vec2f terpos = blob.getPosition();
	terpos.y += blob.getRadius();
	blob.set_Vec2f(terr_pos_property, terpos);
	
	
	InitBrain( this );
	this.server_SetActive( true ); // always running
	blob.set_u8("attack stage", AttackType::attack_fire);
	blob.set_u8("attack counter", 0);
}


void onTick(CBrain@ this)
{
	CBlob @blob = this.getBlob();

	u8 delay = blob.get_u8(delay_property);
	if (delay < 10) delay--;

	// set territory
	if (blob.getTickSinceCreated() == 25)
	{
		Vec2f terpos = blob.getPosition();
		terpos.y += blob.getRadius();
		blob.set_Vec2f(terr_pos_property, terpos);
		//	printf("set territory " + blob.getPosition().x + " " + blob.getPosition().y );
	}

	if (delay == 0)
	{
		delay = 12;

		Vec2f pos = blob.getPosition();
		bool facing_left = blob.isFacingLeft();

		{
			u8 mode = blob.get_u8(state_property);
			u8 personality = blob.get_u8(personality_property);

			//printf("mode " + mode);

			//"blind" attacking
			if (mode == MODE_TARGET)
			{
				CBlob@ target = getBlobByNetworkID(blob.get_netid(target_property));

				if (target is null || XORRandom(blob.get_u8(target_lose_random)) == 0 || target.isInInventory())
				{
					mode = MODE_IDLE;
				}
				else
				{
					Vec2f tpos = target.getPosition();

					f32 search_radius = blob.get_f32(target_searchrad_property);

					if ((tpos - pos).getLength() >= (search_radius))
					{
						mode = MODE_TARGET;
					}

					blob.setKeyPressed((tpos.x < pos.x) ? key_left : key_right, true);

					if (personality & DONT_GO_DOWN_BIT == 0 || (blob.isOnGround() && tpos.y <= pos.y + 3 * blob.getRadius()))
					{
						blob.setKeyPressed((tpos.y < pos.y) ? key_up : key_down, true);
					}
				}
			}
	
			else //mode == idle
			{
				if (personality != 0) //we have a special personality
				{
					f32 search_radius = blob.get_f32(target_searchrad_property);
					string name = blob.getName();

					CBlob@[] blobs;
					blob.getMap().getBlobsInRadius(pos, search_radius, @blobs);

					for (uint step = 0; step < blobs.length; ++step)
					{
						//TODO: sort on proximity? done by engine?
						CBlob@ other = blobs[step];

						if (other is blob) continue; //lets not run away from / try to eat ourselves...

						if (personality & AGGRO_BIT != 0)  //aggressive
						{
							//TODO: flags for these...
							if (other.getName() != name && //dont eat same type of blob
							        other.hasTag("flesh")) //attack flesh blobs
							{
								mode = MODE_TARGET;
								blob.set_netid(target_property, other.getNetworkID());
								break;
							}
						}
					}
				}

				if (blob.getTickSinceCreated() > 30) // delay so we dont get false terriroty pos
				{
					Vec2f territory_pos = blob.get_Vec2f(terr_pos_property);
					f32 territory_range = blob.get_f32(terr_rad_property);

					Vec2f territory_dir = (territory_pos - pos);
					////("territory " + territory_pos.x + " " + territory_pos.y );
					//	printf("territory_dir " + territory_dir.Length() + " " + territory_range  );
					if (territory_dir.Length() > territory_range && !blob.hasAttached())
					{
						//head towards territory

						blob.setKeyPressed((territory_dir.x < 0.0f) ? key_left : key_right, true);
						blob.setKeyPressed((territory_dir.y > 0.0f) ? key_down : key_up, true);
					}
					
				}

			}

			blob.set_u8(state_property, mode);
		}
	}
	else
	{
		PressOldKeys(blob);
	}
	

	blob.set_u8(delay_property, delay);
	bool sawYou = blob.hasTag("saw you");
	SearchTarget( this, sawYou, true );

	CBlob @target = this.getTarget();

	// logic for target

	this.getCurrentScript().tickFrequency = 1;
	if (target !is null)
	{	
		this.getCurrentScript().tickFrequency = 1;

		const f32 distance = (target.getPosition() - blob.getPosition()).getLength();
		f32 visibleDistance;
		const bool visibleTarget = isVisible( blob, target, visibleDistance);

		if (distance > 1.0f)
		{
			if (!sawYou)
			{
				blob.setAimPos( target.getPosition() );
				blob.Tag("saw you");
			}

			u8 stage = blob.get_u8("attack stage");

			const u32 gametime = getGameTime();
			if ((stage == AttackType::attack_fire)) 
			{
				//blob.setKeyPressed( key_action1, true );
				f32 vellen = target.getShape().vellen;
				blob.setAimPos( target.getPosition() + target.getVelocity()*vellen*vellen );
			}

			int x = gametime % 10;
			if (x > 10) {
				stage = AttackType::attack_fire;
			}
			
			blob.set_u8("attack stage", stage);

		}

		LoseTarget( this, target );
		
	}
	return;

}
