var activeAbilityIndex;
var isVector;
var selecting = false;
var startGetError = false;
var error = false;
var activeTarget;
var activeLocation;

GameUI.SetMouseCallback(function(eventName, arg, arg2, arg3)
{ 	
	if(GameUI.GetClickBehaviors() == CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_CAST){
        // $.Msg("矢量施法开始-普通施法")
    

        startGetError = true


        $.Schedule(1 / 144, CheckVectorCastStart);
        
	}
    // $.Msg("ok")
	// return CONTINUE_PROCESSING_EVENT;
});

function CheckVectorCastStart()
{
    // $.Msg(error)
    if(activeAbilityIndex !== undefined)
    {
        const behavior = Abilities.GetBehavior(activeAbilityIndex);
        if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING) !== 0)
        {
            let ownerIndex = Abilities.GetCaster(activeAbilityIndex)
            let abilityName = Abilities.GetAbilityName(activeAbilityIndex)
            let AOERadius = Abilities.GetAOERadius(activeAbilityIndex)
            // let valid = false
            // if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) !== 0)
            // {
            //     let target = GetCursorTarget();
            //     if (target !== undefined && CheckTarget(target)) 
            //         valid = true;
            // }
            // else if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0)
            //     valid = true;
            
            $.Msg(error)
            if(!error)
            {
                error = false;
                isVector = true;
                // selecting = true;
                let cursor = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());
                let sendData = {type:"vector_select_start", ownerIndex: ownerIndex, abilityName : abilityName , AOERadius : AOERadius}
                if(cursor !== undefined && cursor !== null)
                {
                    sendData.x = cursor[0];
                    sendData.y = cursor[1];
                    sendData.z = cursor[2];
                }
                
                if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) !== 0)
                {
                    const target = GetCursorTarget()
                    if (target !== undefined)
                        sendData.targetIndex = target;

                    activeTarget = target;
                }
                else if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0)
                {
                    activeLocation = cursor;
                }
               
                
                GameEvents.SendEventClientSide('ability_custom_indicator', sendData);
                AbilitySelecting();
            }
            selecting = true;
        }
        // else
        // {
        //     Game.PrepareUnitOrders({
        //         OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_VECTOR_TARGET_CANCELED,
        //         UnitIndex: ownerIndex,
        //         Position: undefined,
        //         Queue: false,
        //         OrderIssuer: PlayerOrderIssuer_t.DOTA_ORDER_ISSUER_SELECTED_UNITS,
        //         ShowEffects: false
        //     })
        // }
    }
    
}

$.RegisterForUnhandledEvent("StyleClassesChanged", CheckAbilityState );

function CheckAbilityState(panel){
	if(panel == null){return;}
    if(panel.paneltype == "DOTAErrorMsg")
    {

        if (panel.BHasClass("ShowErrorMsg")) {
            if(startGetError)
            {
                $.Msg("Get ERROR")
                error = true;
            }
            startGetError = false;
        }
    }
    else
    {
        //Check if the panel is an ability or item panel
        const abilityIndex = GetAbilityFromPanel(panel)
        if (abilityIndex >= 0) {
            // $.Msg(GameUI.GetClickBehaviors())
            if (panel.BHasClass("is_active")) {
                if(selecting !== false)
                    return;
                activeAbilityIndex  = abilityIndex
                let ownerIndex = Abilities.GetCaster(activeAbilityIndex)
                let abilityName = Abilities.GetAbilityName(activeAbilityIndex)
                let AOERadius = Abilities.GetAOERadius(activeAbilityIndex)
                if(GameUI.GetClickBehaviors() == CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_CAST){
                    // $.Msg("施法开始")
                    selecting = true;
                    isVector = false;
                    GameEvents.SendEventClientSide('ability_custom_indicator', {type:"select_start", ownerIndex: ownerIndex, abilityName : abilityName , AOERadius : AOERadius});
                    AbilitySelecting();
                }
                if(GameUI.GetClickBehaviors() == CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_VECTOR_CAST){
                    // $.Msg("矢量施法开始-快速施法");
                    startGetError = false;
                    error = false;
                    selecting = true;
                    isVector = true;
                    let cursor = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());
                    let sendData = {type:"vector_select_start", ownerIndex: ownerIndex, abilityName : abilityName , AOERadius : AOERadius}
                    if(cursor !== undefined && cursor !== null)
                    {
                        sendData.x = cursor[0];
                        sendData.y = cursor[1];
                        sendData.z = cursor[2];
                    }

                    const behavior = Abilities.GetBehavior(activeAbilityIndex);
                    if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) !== 0)
                    {
                        const target = GetCursorTarget()
                        if (target !== undefined)
                            sendData.targetIndex = target;
    
                        activeTarget = target;
                    }
                    else if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0)
                    {
                        activeLocation = cursor;
                    }

                    GameEvents.SendEventClientSide('ability_custom_indicator', sendData);
                    AbilitySelecting();
                }
            } else {
                if(selecting === true && activeAbilityIndex === abilityIndex)
                {
                    let ownerIndex = Abilities.GetCaster(activeAbilityIndex)
                    let abilityName = Abilities.GetAbilityName(activeAbilityIndex)
                    selecting = false;
                    // $.Msg("施法结束")
                    activeAbilityIndex = undefined;
                    isVector = undefined;
                    activeTarget = undefined;
                    activeLocation = undefined;
                    error = false;
                    GameEvents.SendEventClientSide('ability_custom_indicator', {type:"select_end", ownerIndex: ownerIndex, abilityName : abilityName});
                }
            }
        }
    }
}

function AbilitySelecting()
{
    if(activeAbilityIndex !== undefined)
    {
        const ownerIndex = Abilities.GetCaster(activeAbilityIndex)
        const abilityName = Abilities.GetAbilityName(activeAbilityIndex)

        let cursor = GameUI.GetScreenWorldPosition(GameUI.GetCursorPosition());

        const target = GetCursorTarget()
        const behavior = Abilities.GetBehavior(activeAbilityIndex);

        if(cursor !== undefined && cursor !== null)
        {   
            let sendData = {ownerIndex: ownerIndex, abilityName : abilityName , overlap : false}

            if(isVector)
            {
                sendData.type = "vector_selecting"
                if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) !== 0)
                {
                    sendData.targetIndex = activeTarget
                    if (target !== undefined && target == activeTarget) 
                    {
                        const forward = Entities.GetForward(activeTarget);
                        sendData.forwardX = forward[0];
                        sendData.forwardY = forward[1];
                        sendData.forwardZ = forward[2];
                        sendData.overlap = true;
                        // const targetOrigin = Entities.GetAbsOrigin(target)
                        // cursor = Vector_add(targetOrigin , Game.Normalized(Vector_sub(targetOrigin , Entities.GetAbsOrigin(ownerIndex))));
                        // if(ownerIndex == target)
                        //     cursor = Vector_add(cursor, Entities.GetForward(target));
                    }
                }
                else if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_POINT) !== 0)
                {
                    if (activeLocation !== undefined) 
                    {
                        sendData.startX = activeLocation[0];
                        sendData.startY = activeLocation[1];
                        sendData.startZ = activeLocation[2];
                        if(cursor[0] == activeLocation[0] && cursor[1] == activeLocation[1] && cursor[2] == activeLocation[2])
                        {
                            const forward = Entities.GetForward(ownerIndex);
                            sendData.forwardX = forward[0];
                            sendData.forwardY = forward[1];
                            sendData.forwardZ = forward[2];
                            sendData.overlap = true;
                        }
                            
                            // cursor = activeLocation + Game.Normalized(activeLocation - Entities.GetAbsOrigin(ownerIndex))
                    }   
                }
                
                sendData.x = cursor[0];
                sendData.y = cursor[1];
                sendData.z = cursor[2];
                GameEvents.SendEventClientSide('ability_custom_indicator', sendData);
            }
            else
            {
                sendData.type = "selecting"
                if((behavior & DOTA_ABILITY_BEHAVIOR.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) !== 0)
                {
                    if (target !== undefined && CheckTarget(target)) 
                        cursor = Entities.GetAbsOrigin(target);
                }
                // $.Msg("正在选取施法目标")
                if(cursor !== undefined && cursor !== null)
                {
                    sendData.x = cursor[0];
                    sendData.y = cursor[1];
                    sendData.z = cursor[2];
                }
                GameEvents.SendEventClientSide('ability_custom_indicator', sendData);
            }
        }
        $.Schedule(1 / 144, AbilitySelecting);
    }
}

function GetAbilityFromPanel(panel) {
	if (panel.paneltype == "DOTAAbilityPanel") {
		// Be sure that it is a default ability Button
		const parent = panel.GetParent();
		if (parent != undefined && (parent.id == "abilities" || parent.id == "inventory_list")) {
			const abilityImage = panel.FindChildTraverse("AbilityImage")
			let abilityIndex = abilityImage.contextEntityIndex;
			let abilityName = abilityImage.abilityname
			//Will be undefined for items
			if (abilityName) {
				return abilityIndex;
			}

			//Return item entindex instead
			const itemImage = panel.FindChildTraverse("ItemImage")
			abilityIndex = itemImage.contextEntityIndex;
			return abilityIndex;
		}
	}
	return -1;
}


function CheckTarget(target)
{
    const behavior = Abilities.GetBehavior(activeAbilityIndex);
     
    const unit_target = valueAtBit(behavior,4);
    
        
    if (unit_target)
    {
        if(target !== undefined)
        {
            const abilityTeamType = Abilities.GetAbilityTargetTeam(activeAbilityIndex);
            const Isenemy = Entities.IsEnemy(target);
            let isTrueTarget = false;
            switch(abilityTeamType)
            {
                case DOTA_UNIT_TARGET_TEAM.DOTA_UNIT_TARGET_TEAM_ENEMY:
                    if(Isenemy)
                    isTrueTarget = true;
                    break;
                case DOTA_UNIT_TARGET_TEAM.DOTA_UNIT_TARGET_TEAM_FRIENDLY:
                    if(!Isenemy)
                    isTrueTarget = true;
                    break;
                    case DOTA_UNIT_TARGET_TEAM.DOTA_UNIT_TARGET_TEAM_BOTH:
                    isTrueTarget = true;
                    break;
            }
            if(!isTrueTarget)
                return false;
            
            const abilityTargetType = Abilities.GetAbilityTargetType(activeAbilityIndex);
    
            if(!((valueAtBit(abilityTargetType,1) && Entities.IsHero(target))||
                (valueAtBit(abilityTargetType,2) && Entities.IsCreep(target))||
                (valueAtBit(abilityTargetType,3) && Entities.IsBuilding(target))||
                (valueAtBit(abilityTargetType,4) && Entities.IsCourier(target))||
                (valueAtBit(abilityTargetType,5) && Entities.IsOther(target))))
                {
                    return false;
                }
                
            const abilityTargetFlag = Abilities.GetAbilityTargetFlags(activeAbilityIndex);
    
            const isRangedAttacker = Entities.IsRangedAttacker(target);
            const IsEnemy = Entities.IsEnemy(target);
            const IsMagicImmune = Entities.IsMagicImmune(target);
    
            if((valueAtBit(abilityTargetFlag,2) && !isRangedAttacker)||
                (valueAtBit(abilityTargetFlag,3) && isRangedAttacker)||
                (!valueAtBit(abilityTargetFlag,4) && !Entities.IsAlive(target))||
                (!valueAtBit(abilityTargetFlag,5) && IsMagicImmune && IsEnemy)||
                (valueAtBit(abilityTargetFlag,6) && IsMagicImmune && !IsEnemy)||
                (valueAtBit(abilityTargetFlag,7) && Entities.IsInvulnerable(target))||
                (valueAtBit(abilityTargetFlag,9) && Entities.IsInvisible(target) && IsEnemy)||
                (valueAtBit(abilityTargetFlag,10) && Entities.IsAncient(target))||
                (valueAtBit(abilityTargetFlag,11) && !Entities.IsControllableByAnyPlayer(target))||
                (valueAtBit(abilityTargetFlag,12) && Entities.IsDominated(target))||
                (valueAtBit(abilityTargetFlag,13) && Entities.IsSummoned(target))||
                (valueAtBit(abilityTargetFlag,14) && Entities.IsIllusion(target))||
                (valueAtBit(abilityTargetFlag,15) && Entities.IsAttackImmune(target))||
                (valueAtBit(abilityTargetFlag,18) && Entities.IsCreepHero(target)) ||
                (valueAtBit(abilityTargetFlag,20) && Entities.IsNightmared(target)))
                    {
                    return false;
                    }
        }
    }

    return true;
}

function GetCursorTarget()
{
    const cursor = GameUI.GetCursorPosition();
    let target = undefined;

    const targets = GameUI.FindScreenEntities(cursor);
                
    for ( var t_target of targets ) 
    {
        if ( !t_target.accurateCollision )
            continue;
        target = t_target.entityIndex;
    }
    
    if(target == undefined && targets.length != 0)
    target = targets[0].entityIndex;

    return target
}



function valueAtBit(num, bit) {
    return ((num >> (bit -1)) & 1) == 1;
}

function Vector_add(vec1, vec2)
{
	return [vec1[0] + vec2[0], vec1[1] + vec2[1], vec1[2] + vec2[2]];
}

function Vector_sub(vec1, vec2)
{
	return [vec1[0] - vec2[0], vec1[1] - vec2[1], vec1[2] - vec2[2]];
}

function Vector_mult(vec, mult)
{
	return [vec[0] * mult, vec[1] * mult, vec[2] * mult];
}

function Vector_negate(vec)
{
	return [-vec[0], -vec[1], -vec[2]];
}

function Vector_flatten(vec)
{
	return [vec[0], vec[1], 0];
}

function Vector_raiseZ(vec, inc)
{
	return [vec[0], vec[1], vec[2] + inc];
}