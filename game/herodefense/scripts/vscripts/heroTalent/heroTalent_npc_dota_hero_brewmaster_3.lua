heroTalent_npc_dota_hero_brewmaster_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_brewmaster_3", "heroTalent/heroTalent_npc_dota_hero_brewmaster_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_brewmaster_3_effect", "heroTalent/heroTalent_npc_dota_hero_brewmaster_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_brewmaster_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_brewmaster_3"
end




function heroTalent_npc_dota_hero_brewmaster_3:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile_debuff_explosion.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/talent/brewmaster_3/effect/effect.vpcf", context )
end








modifier_heroTalent_npc_dota_hero_brewmaster_3 = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_brewmaster_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_brewmaster_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_brewmaster_3:OnCreated(keys)
	if IsServer() then

		self:StartIntervalThink(0.1)
		self.buff_duration = self:GetAbility():GetSpecialValueFor("duration")
		self.str_to_block = self:GetAbility():GetSpecialValueFor("str_to_block")*0.01

	end

end
function modifier_heroTalent_npc_dota_hero_brewmaster_3:OnRefresh(keys)
	if IsServer() then
		self.buff_duration = self:GetAbility():GetSpecialValueFor("duration")
		self.str_to_block = self:GetAbility():GetSpecialValueFor("str_to_block")*0.01

	end

end



function modifier_heroTalent_npc_dota_hero_brewmaster_3:OnIntervalThink()
	local parent = self:GetParent()
	parent:SetOriginalModel("models/override_model/brewmaster/brewmaster_1_set_000.vmdl")
	parent:UpdateOriginModel()
	self:StartIntervalThink(-1)
	local model = parent:FirstMoveChild()
	-- self.modelName = self.hero:GetModelName()
	local model_list = {}
	while model ~= nil do
		if model:GetClassname() == "dota_item_wearable" then
			-- print(model)
			-- PrintTable(model)
			-- print(model:GetModelName())

			table.insert(model_list,model)
			
		end
		model = model:NextMovePeer()
	end
	for _, model in ipairs(model_list) do
		UTIL_Remove(model)
	end	
end

function modifier_heroTalent_npc_dota_hero_brewmaster_3:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
	}
end




function modifier_heroTalent_npc_dota_hero_brewmaster_3:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel()) < 1 then
		return
	end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_brewmaster_3_effect", 
	{duration=self.buff_duration,stack = self.str_to_block*self:GetParent():GetStrength()})
end




modifier_heroTalent_npc_dota_hero_brewmaster_3_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:IsHidden() 			return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:RemoveOnDeath() return false end
-- function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:GetEffectName() return "particles/econ/items/tiny/tiny_prestige/tiny_prestige_lvl1_ambient.vpcf" end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:GetStatusEffectName() return "particles/rebuild/talent/brewmaster_3/effect/effect.vpcf" end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+keys.stack,self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("max_block")*0.01))
	end
end
function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+keys.stack,self:GetParent():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("max_block")*0.01))
	end
end

function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
	}
end


function modifier_heroTalent_npc_dota_hero_brewmaster_3_effect:AdvancedGetModifierTotal_ConstantBlock(keys)
	if not IsServer() then
		return self:GetStackCount()
		-- return 0 
	end
    -- if keys.block_disabled then
    --     return 0 
    -- end
	local stack = self:GetStackCount()
	if stack<=0 then
		self:Destroy()
		return 0
	end
    --计算护盾值
	if keys.damage >  self:GetStackCount()then
		self:SetStackCount(0)
		self:GetAbility():UseResources(true, true, true,true)
	else
        self:SetStackCount(self:GetStackCount()- math.max(0, keys.damage))
        stack=keys.damage
	end
	self:GetParent():EmitSound("Hero_Mars.Shield.Cast.Small")
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile_debuff_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	DestroyParticleByDelay(nFXIndex,1.5)

	
	return stack

end