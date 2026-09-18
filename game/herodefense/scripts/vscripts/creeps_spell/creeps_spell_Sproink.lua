creeps_spell_Sproink = class({})
LinkLuaModifier("modifier_creeps_spell_Sproink_motion", "creeps_spell/creeps_spell_Sproink.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_creeps_spell_Sproink_buff", "creeps_spell/creeps_spell_Sproink.lua", LUA_MODIFIER_MOTION_NONE) 
LinkLuaModifier("modifier_creeps_spell_Sproink_passive", "creeps_spell/creeps_spell_Sproink.lua", LUA_MODIFIER_MOTION_NONE) 
function creeps_spell_Sproink:IsHiddenWhenStolen() return false end
function creeps_spell_Sproink:IsStealable() return true end
function creeps_spell_Sproink:IsRefreshable() 			return true end
function creeps_spell_Sproink:GetIntrinsicModifierName() return "modifier_creeps_spell_Sproink_passive" end



function creeps_spell_Sproink:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local cur_pos=self:GetCursorPosition()
	local fw = self:GetSpecialValueFor("dis")
    local dis=TG_Distance(caster_pos,cur_pos+caster:GetForwardVector()*fw)--
	local dir=TG_Direction(caster_pos,cur_pos)
	local sp=self:GetSpecialValueFor("speed")
	if dis > fw then
		dis=fw
	end
    local time=dis/sp
	caster:EmitSound("Hero_Enchantress.EnchantCreep")
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_Sproink_motion", {duration=time,dir=dir,sp=sp})
end

modifier_creeps_spell_Sproink_motion=class({})

function modifier_creeps_spell_Sproink_motion:IsHidden() 			return true end
function modifier_creeps_spell_Sproink_motion:IsPurgable() 			return false end
function modifier_creeps_spell_Sproink_motion:IsPurgeException() 	return false end

function modifier_creeps_spell_Sproink_motion:OnCreated(tg)
    if not IsServer() then
        return
	end
	-- local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_FARTHEST, false)               
	-- if #heros>0 then 
    --     for a=1,4 do    
	-- 		self:GetParent():PerformAttack(heros[RandomInt(1,#heros)],true, false, true, false, true, false, false)
    --     end
    -- end
    local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_trail_blossoms/courier_trail_blossoms.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle( particle, false, false, 20, false, false ) 
	self.SP=tg.sp
    self.DIR=ToVector(tg.dir)
		if not self:ApplyHorizontalMotionController()then 
			self:SafeDestroy()
		end

end




function modifier_creeps_spell_Sproink_motion:UpdateHorizontalMotion( t, g )
    if not IsServer() then
        return
	end  
	
	if  not self:GetParent():IsAlive() then
        self:SafeDestroy() 
    else
		self:GetParent():SetAbsOrigin(self:GetParent():GetAbsOrigin()+self.DIR* (self.SP / (1.0 / FrameTime())))
    end

end

function modifier_creeps_spell_Sproink_motion:OnHorizontalMotionInterrupted()
    if  IsServer() then
		self:SafeDestroy()
	end
end


function modifier_creeps_spell_Sproink_motion:OnDestroy()

    if  IsServer() then
		self:GetParent():AddNewModifier( self:GetParent(),  self:GetAbility(), "modifier_creeps_spell_Sproink_buff", {})
		self:GetParent():RemoveHorizontalMotionController(self)
		FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
		-- self:GetParent():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位

		-- self:GetParent():RemoveHorizontalMotionController(self)
	end
end

function modifier_creeps_spell_Sproink_motion:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}
end

function modifier_creeps_spell_Sproink_motion:GetOverrideAnimation()
    return ACT_DOTA_CAST_ABILITY_4
end

function modifier_creeps_spell_Sproink_motion:GetModifierTurnRate_Percentage() 	
	return 100
end


modifier_creeps_spell_Sproink_buff= advanced_modifier({})

function modifier_creeps_spell_Sproink_buff:IsHidden() 			return false end
function modifier_creeps_spell_Sproink_buff:IsPurgable() 		return false end
function modifier_creeps_spell_Sproink_buff:IsPurgeException() 	return false end
function modifier_creeps_spell_Sproink_buff:OnCreated()
	self:SetStackCount(1)
end

function modifier_creeps_spell_Sproink_buff:OnRefresh()
	self:IncrementStackCount()
end

function modifier_creeps_spell_Sproink_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

function modifier_creeps_spell_Sproink_buff:Advanced_GetModifierAttackRangeBonus()
	return 10*self:GetStackCount()
end



modifier_creeps_spell_Sproink_passive= advanced_modifier({})

function modifier_creeps_spell_Sproink_passive:IsHidden() 			return true end
function modifier_creeps_spell_Sproink_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Sproink_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Sproink_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	local parent = self:GetParent()
	local passive = self:GetAbility()
	if not IsServer() or parent:PassivesDisabled() or keys.attacker:IsBuilding() or parent:IsIllusion() then
		return
	end
	if not parent.pattern_3 then
		
		return
	end
	if passive:IsFullyCastable() and keys.damage>=300 then

		parent:SetCursorPosition(keys.attacker:GetAbsOrigin())
		passive:UseResources(true, true, true,true)
		passive:OnSpellStart()
		parent:SetBaseDamageMax(parent:GetBaseDamageMax()*1.01)
		parent:SetBaseDamageMin(parent:GetBaseDamageMin()*1.01)
		ProjectileManager:ProjectileDodge(parent) --弹道躲闪
		return -100
	end


	return 0
	
end
function modifier_creeps_spell_Sproink_passive:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
