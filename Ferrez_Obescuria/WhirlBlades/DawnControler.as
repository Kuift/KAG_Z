#include "Hitters_mod.as";
#include "Knocked.as";
#include "GenericButtonCommon.as";
const f32 max_range = 16.00f;
void onInit(CBlob@ this)
{
	this.Tag("ignore_saw");
    this.addCommandID("activate");
	this.getSprite().SetZ(10.0f);
}

void GetButtonsFor(CBlob@ this, CBlob@ caller)
{
	if (!canSeeButtons(this, caller)) return;
    if (!this.isAttachedTo(caller)) return;

	CBitStream params;
	params.write_u16(caller.getNetworkID());
	caller.CreateGenericButton(11, Vec2f_zero, this, this.getCommandID("activate"), "Activate", params);
}

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{
    if (cmd == this.getCommandID("activate"))
    {
        this.server_Hit(this, this.getPosition(), Vec2f(0,0), 1.0f, Hitters_mod::fall, true);

        CBlob@ caller = getBlobByNetworkID(params.read_u16());
        if (caller.getPlayer() !is null)
        {
            if (isServer())
            {
                CBlob@ lightA = server_CreateBlob("whirlblade", caller.getTeamNum(), caller.getPosition());
                lightA.Tag("SurgeLight");
                lightA.SetDamageOwnerPlayer(caller.getPlayer());
				this.server_Hit(caller, caller.getPosition(), Vec2f(0,0), 1.0f, Hitters_mod::fall, true);

            }
        }
    }
}


void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	this.server_setTeamNum(attached.getTeamNum());
}


