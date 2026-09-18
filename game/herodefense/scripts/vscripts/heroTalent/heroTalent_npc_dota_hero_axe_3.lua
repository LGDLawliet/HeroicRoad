heroTalent_npc_dota_hero_axe_3 = heroTalent_npc_dota_hero_axe_3 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_3", "heroTalent/heroTalent_npc_dota_hero_axe_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_axe_3_active", "heroTalent/heroTalent_npc_dota_hero_axe_3", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_axe_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_axe_3"
end
function heroTalent_npc_dota_hero_axe_3:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_shard_fan_of_knives_debuff.vpcf", context )
end

------------------------
modifier_heroTalent_npc_dota_hero_axe_3 = modifier_heroTalent_npc_dota_hero_axe_3 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_axe_3:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_axe_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_axe_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_axe_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_axe_3:OnCreated(keys)
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
	self.trigger = {}
end
function modifier_heroTalent_npc_dota_hero_axe_3:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_Wave_Start = {},
		MODIFIER_EVENT_ON_Wave_End = {},
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
end

function modifier_heroTalent_npc_dota_hero_axe_3:Advanced_GetModifierBonusStats_Strength()
	return self.bonus_str * self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_axe_3:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor * self:GetStackCount()
end
function modifier_heroTalent_npc_dota_hero_axe_3:OnWaveStart()
    if IsServer() then
		if self:GetAbility():GetAutoCastState() then
			self.trigger = true
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_axe_3_active", {duration = self:GetAbility():GetSpecialValueFor("pig_duration")})
		else
			self.trigger = nil
		end
	end
end
function modifier_heroTalent_npc_dota_hero_axe_3:OnWaveEnd()
    if IsServer() then
		local gold = self:GetParent():GetGold()
		local heroes = GetAllRealHeroes()
		if #heroes<=1 and not self.trigger then
			return
		end

		for _, unit in ipairs(heroes) do
			if gold > unit:GetGold() and not self.trigger then
				return
			end
		end
		self:IncrementStackCount()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_heroTalent_npc_dota_hero_axe_3_active", {duration = 7})
	end
end

modifier_heroTalent_npc_dota_hero_axe_3_active = advanced_modifier({})
function modifier_heroTalent_npc_dota_hero_axe_3_active:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_axe_3_active:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_axe_3_active:IsDebuff()	return false end


function modifier_heroTalent_npc_dota_hero_axe_3_active:CheckState()
	return{
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
function modifier_heroTalent_npc_dota_hero_axe_3_active:DeclareFunctions()	
		local decFuncs = {
			MODIFIER_PROPERTY_MODEL_CHANGE,
		}
		
	return decFuncs	
end


function modifier_heroTalent_npc_dota_hero_axe_3_active:GetModifierModelChange()
	return "models/props_gameplay/pig.vmdl"
end

function modifier_heroTalent_npc_dota_hero_axe_3_active:OnCreated()
	if IsServer() then
		self:GetParent():EmitSound("Item.PigPole.Target")
		local pfx_name = "particles/econ/items/shadow_shaman/shadow_shaman_sheepstick/shadowshaman_voodoo_sheepstick.vpcf"
		local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)
	end
  
end
