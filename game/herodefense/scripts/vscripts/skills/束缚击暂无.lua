tg_wr_shack=tg_wr_shack or class({})
LinkLuaModifier("modifier_tg_wr_shack_tree", "tg/tg_heros/hero_tg_windrunner/TG_shackleshot.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tg_wr_shack_buff", "tg/tg_heros/hero_tg_windrunner/TG_shackleshot.lua", LUA_MODIFIER_MOTION_NONE)

function tg_wr_shack:IsHiddenWhenStolen() return false end
function tg_wr_shack:IsStealable() return true end
function tg_wr_shack:IsNetherWardStealable() return true end
function tg_wr_shack:IsRefreshable() 			return true end
function tg_wr_shack:ProcsMagicStick() 			return true end

function tg_wr_shack:OnSpellStart()
    local caster=self:GetCaster()
    local team=caster:GetTeamNumber()
    local casterpos=caster:GetAbsOrigin()
    local dis=self:GetSpecialValueFor("dis")
    curpos=self:GetCursorPosition()  
    right=caster:GetRightVector()*(dis/2)
    left=caster:GetRightVector()*-(dis/2)
    
    local NULL1=CreateUnitByName("npc_dummy_unit", curpos+right, false, nil, nil, team)
    local NULL2=CreateUnitByName("npc_dummy_unit", curpos+left, false, nil, nil, team)

    EmitSoundOn("Hero_Windrunner.ShackleshotCast", caster)
    AddFOWViewer(caster:GetTeamNumber(),curpos, 1000, 3, false)

    local projectileTable1 = 
	{
		Target = NULL1,
		Source = caster,
		Ability = self,	
		EffectName = "particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot.vpcf",
		iMoveSpeed = 1000,
		vSourceLoc = casterpos,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
	}
    ProjectileManager:CreateTrackingProjectile(projectileTable1)

    local projectileTable2 = 
	{
		Target = NULL2,
		Source = caster,
		Ability = self,	
		EffectName = "particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot.vpcf",
		iMoveSpeed = 1000,
		vSourceLoc =casterpos,
		bDrawsOnMinimap = false,
		bDodgeable = false,
		bIsAttack = false,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 5,
		bProvidesVision = false,
	}
    ProjectileManager:CreateTrackingProjectile(projectileTable2)
 
end


function tg_wr_shack:OnProjectileHit(target, location)
    local caster=self:GetCaster()
    local  tl=curpos+right
    local  tr=curpos+left
    local dur=self:GetSpecialValueFor("treedur")
    local TREETABLE=
    {
        "models/props_tree/newbloom_tree.vmdl",
        "maps/jungle_assets/trees/kapok/export/kapok_003.vmdl",
        "maps/jungle_assets/trees/flytrap/jungle_flytrap01.vmdl",
        "maps/journey_assets/props/trees/journey_armandpine/journey_armandpine_01_inspector.vmdl",
        "models/props_tree/frostivus_tree.vmdl",
        "models/props_tree/tree_pine_04.vmdl",
    }
    local treemodel=TREETABLE[RandomInt(1, #TREETABLE)]
    local tree1=CreateTempTreeWithModel(tl,dur,treemodel)
    local tree2=CreateTempTreeWithModel( tr,dur,treemodel)
    local ct1=tree1:GetAbsOrigin() + tree1:GetUpVector()*150
    local ct2=tree2:GetAbsOrigin() + tree2:GetUpVector()*150
    local time=0
    Timers:CreateTimer({
		useGameTime = false,
		endTime =0.25, 
		callback = function()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/wr_ti8_immortal_shoulder/wr_ti8_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(pfx, 0,ct1)
    ParticleManager:SetParticleControl(pfx, 1,ct2)
    ParticleManager:SetParticleControl(pfx, 2, Vector(dur,0,0))
    
            Timers:CreateTimer(0, function()
                local enemies1 = FindUnitsInLine(caster:GetTeam(),  ct1, ct2, caster, self:GetSpecialValueFor("wh"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
                for _,tar in pairs(enemies1) do
                    if TG_Enemy_GET(tar,caster) then
                        local Knockback ={
                            should_stun = 0,
                            knockback_duration = 0.4,
                            duration = 0.4,
                            knockback_distance = 300,
                            knockback_height = 400,
                            center_x =  tar:GetAbsOrigin().x+tar:GetForwardVector(),
                            center_y =  tar:GetAbsOrigin().y+tar:GetRightVector(),
                            center_z =  tar:GetAbsOrigin().z
                        }

                        if not tar:HasModifier("modifier_knockback") then
                        tar:AddNewModifier(tar,self, "modifier_knockback", Knockback)
                        end
                        tar:AddNewModifier(caster, self, "modifier_tg_wr_shack_tree", {duration=self:GetSpecialValueFor("spdur")})  
                        tar:AddNewModifier(caster, self, "modifier_tg_wr_shack_buff", {duration=self:GetSpecialValueFor("spdur")})  
                    else
                        local Knockback ={
                            should_stun = 0,
                            knockback_duration = 1,
                            duration = 0.3,
                            knockback_distance = 1000,
                            knockback_height = 450,
                            center_x =  tar:GetAbsOrigin().x-tar:GetForwardVector(),
                            center_y =  tar:GetAbsOrigin().y-tar:GetRightVector(),
                            center_z =  tar:GetAbsOrigin().z
                        }
                
                        tar:AddNewModifier(tar,self, "modifier_knockback", Knockback)
                    end
                end
                  if time>=dur then        
                     ParticleManager:DestroyParticle(pfx, true)
                     pfx=nil       
                     return nil
                else
                    time=time+0.1
                    return 0.1
                end
            end)


        
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(),target:GetAbsOrigin(),nil,self:GetSpecialValueFor("stunrd")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_wr_2"),DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BUILDING,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)
    for _,tar in pairs(enemies) do
        if  tar:TriggerStandardTargetSpell(self) then
            return
           end
           pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, nil) 
           ParticleManager:SetParticleControlEnt(pfx, 0, tar, PATTACH_POINT, "attach_hitloc", tar:GetAbsOrigin(), true)
           ParticleManager:SetParticleControl(pfx, 1, target:GetAbsOrigin() + target:GetUpVector()*150)
           ParticleManager:SetParticleControl(pfx, 2, Vector(self:GetSpecialValueFor("stun"),0,0))
           EmitSoundOn("Hero_Windrunner.ShackleshotBind", target)
           tar:AddNewModifier(caster, self, "modifier_stunned", {duration=self:GetSpecialValueFor("stun")+self:GetCaster():TG_GetTalentValue("special_bonus_imba_wr_1")})  
        end

    end
})

end


modifier_tg_wr_shack_tree=modifier_tg_wr_shack_tree or class({})

function modifier_tg_wr_shack_tree:IsDebuff()return true end
function modifier_tg_wr_shack_tree:IsPurgable() 			return true end
function modifier_tg_wr_shack_tree:IsPurgeException() 		return true end
function modifier_tg_wr_shack_tree:IsHidden()				return false end
function modifier_tg_wr_shack_tree:RemoveOnDeath() 	return true end
function modifier_tg_wr_shack_tree:DeclareFunctions()return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}end
function modifier_tg_wr_shack_tree:GetModifierMoveSpeedBonus_Percentage()return self:GetAbility():GetSpecialValueFor("sp") end

modifier_tg_wr_shack_buff=modifier_tg_wr_shack_buff or class({})
function modifier_tg_wr_shack_buff:IsBuff()return true end
function modifier_tg_wr_shack_buff:IsPurgable() 			return false end
function modifier_tg_wr_shack_buff:IsPurgeException() 		return false end
function modifier_tg_wr_shack_buff:IsHidden()				return true end
function modifier_tg_wr_shack_buff:RemoveOnDeath() 	return true end
function modifier_tg_wr_shack_buff:RemoveOnDeath() 	return true end
function modifier_tg_wr_shack_buff:CheckState() return{ [MODIFIER_STATE_NO_UNIT_COLLISION] = true,}end