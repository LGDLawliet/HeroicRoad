heroTalent_npc_dota_hero_templar_assassin = class({})

LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin", "heroTalent/heroTalent_npc_dota_hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("modifier_heroTalent_npc_dota_hero_templar_assassin_effect", "heroTalent/heroTalent_npc_dota_hero_templar_assassin", LUA_MODIFIER_MOTION_NONE)

function heroTalent_npc_dota_hero_templar_assassin:IsHiddenWhenStolen() 		return false end
function heroTalent_npc_dota_hero_templar_assassin:IsRefreshable() 			return true end
function heroTalent_npc_dota_hero_templar_assassin:IsStealable() 				return true end
function heroTalent_npc_dota_hero_templar_assassin:IsNetherWardStealable()		return true end
function heroTalent_npc_dota_hero_templar_assassin:GetIntrinsicModifierName() return "modifier_heroTalent_npc_dota_hero_templar_assassin" end
function heroTalent_npc_dota_hero_templar_assassin:Spawn()
	if IsServer() then
		local caster = self:GetCaster()
		caster:GameTimer(0.1, function()
			if IsValid(self) then
				local costKeys = {
					baseCost = 500,
					to_level2_cost = 1000,
					to_level3_cost = 1500,
					upgrade_cost = 500,
					
				}
				skillshop:LearnTalentDefaultAbility(caster,"Refraction",costKeys)
		
			end
		end)
	
	end

end

-------------------------------------------------
modifier_heroTalent_npc_dota_hero_templar_assassin = class({})

function modifier_heroTalent_npc_dota_hero_templar_assassin:IsDebuff()			return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin:IsHidden() 			return true end
function modifier_heroTalent_npc_dota_hero_templar_assassin:IsPurgable() 		    return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin:OnCreated(keys)
    if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
        --self:StartIntervalThink(0.3)     
    end
end
function modifier_heroTalent_npc_dota_hero_templar_assassin:OnIntervalThink()


    
   if self:GetAbility():IsCooldownReady() then
        local hero = self:GetParent()
        hero:AddNewModifier(hero, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_templar_assassin_effect", {})
        self:GetAbility():UseResources(true, true, true,true)
        hero:EmitSound("Hero_TemplarAssassin.Refraction")
   end


  
end





---------------------------------因天赋重做暂时注销*-------------------------------------


modifier_heroTalent_npc_dota_hero_templar_assassin_effect = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:GetEffectName() return "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf" end
-- function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:OnCreated(keys)
    if IsServer() then
        self:SetStackCount(8)
        local particle_cast = "particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
        ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
        ParticleManager:SetParticleControlEnt(
			effect_cast,
			5,
			self:GetParent(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)

		-- buff particle
		self:AddParticle(
			effect_cast,
			false, -- bDestroyImmediately
			false, -- bStatusEffect
			-1, -- iPriority
			false, -- bHeroEffect
			false -- bOverheadEffect
		)
    end
end
function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:OnRefresh(keys)
    if IsServer() then
        self:SetStackCount(8)
    end
end

function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:Advanced_GetModifierIncomingDamage_Percentage(keys)	
	if IsClient() then
		return 0
	end
    if self:GetStackCount()<=0 then
        self:SafeDestroy()
        return
    end
    if keys.damage<=100 then
        return 0
    end
    self:DecrementStackCount()
    self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
    if keys.damage>=self:GetParent():GetMaxHealth()*0.5 then
       
        return -60
    end
    return -100
end


function modifier_heroTalent_npc_dota_hero_templar_assassin_effect:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
