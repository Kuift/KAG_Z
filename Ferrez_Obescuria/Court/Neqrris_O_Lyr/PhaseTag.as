// Lantern script
#include "Knocked.as";
#include "/Entities/Common/Attacks/Hitters.as";
#include "FireCommon.as";


void onInit(CBlob@ this)
{
 
this.getCurrentScript().tickFrequency = 1;
}

void onTick(CBlob@ this)
{

	
	if ((this.getHealth() < 21.0))
	{
	
		this.Tag("PhaseOne");
	
	}
	
	if ((this.getHealth() < 15.0))
	{
	
		this.Tag("PhaseTwo");
	
	}
	
	if ((this.getHealth() < 10.0)) 
	{
	
		this.Tag("PhaseThree");
	
	}
	
	if ((this.getHealth() < 5.0)) 
	{
	
		this.Tag("PhaseFour");
	
	}
	
	
	
}




