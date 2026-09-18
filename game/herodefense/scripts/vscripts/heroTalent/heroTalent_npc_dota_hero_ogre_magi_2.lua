heroTalent_npc_dota_hero_ogre_magi_2 = heroTalent_npc_dota_hero_ogre_magi_2 or class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ogre_magi_2", "heroTalent/heroTalent_npc_dota_hero_ogre_magi_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff", "heroTalent/heroTalent_npc_dota_hero_ogre_magi_2", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_ogre_magi_2:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_ogre_magi_2"
end
function heroTalent_npc_dota_hero_ogre_magi_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf", context )

end


modifier_heroTalent_npc_dota_hero_ogre_magi_2 =modifier_heroTalent_npc_dota_hero_ogre_magi_2 or class({})

function modifier_heroTalent_npc_dota_hero_ogre_magi_2:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, 
	}
	return funcs
end

function modifier_heroTalent_npc_dota_hero_ogre_magi_2:OnAbilityFullyCast(keys)
	if IsServer() then
		if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
			return 
		end
		if keys.ability:GetCooldown(keys.ability:GetLevel()) <= 1 then
			return
		end
		if  not keys.ability:IsRefreshable() then
			return
		end
		if keys.ability:IsItem() then
			if not keys.ability:IsCooldownReady() and self:GetCaster():GetRandomEffect(15,INT_TYPE,0.5)>=RandomInt(1, 100) then
				local time = keys.ability:GetCooldownTimeRemaining()
				self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.x1")
				keys.ability:EndCooldown()
				local p_name = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf"
				local nFXIndex = ParticleManager:CreateParticle( p_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			return
		end

		local caster = self:GetCaster()
		local modifiers = caster:FindAllModifiersByName("modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff")
		local found = false
		for _, modifier in ipairs(modifiers) do
			if modifier:GetAbility()==keys.ability then
				modifier:IncrementStackCount()
				found = true
				if modifier:GetStackCount()>=6 then
					-- local time = keys.ability:GetCooldownTimeRemaining()
					self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.x1")
					keys.ability:EndCooldown()
					local p_name = "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf"
					local nFXIndex = ParticleManager:CreateParticle( p_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
					ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 1, 1 ) )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					modifier:SafeDestroy()
				end
			end
		end

		if not found then
			local modifier = caster:AddNewModifier(caster, keys.ability, "modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff", {})
			if modifier then
				modifier:SetStackCount(1)
			end
		end

	
	
		
	end
end



modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff = class({})

function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:OnCreated(keys)
-- 	if IsServer() then
-- 		self:StartIntervalThink(5)
-- 	end
-- end
-- function modifier_heroTalent_npc_dota_hero_ogre_magi_2_buff:OnIntervalThink()
-- 	local ability = self:GetAbility()
-- 	if not ability then
-- 		self:SafeDestroy()
-- 	end
-- end