void onTick(CBlob@ this){
    if(this is null){return;}
	AttachmentPoint@ point = this.getAttachments().getAttachmentPointByName("PICKUP");
	CBlob@ holder = point.getOccupied();
    if(holder !is null){
        if(holder.getCarriedBlob().getName() == "fallrune"){
            holder.RemoveScript("FallDamage.as");
        }
    }
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint){
    detached.AddScript("FallDamage.as"); //required to re-add fall damage
}