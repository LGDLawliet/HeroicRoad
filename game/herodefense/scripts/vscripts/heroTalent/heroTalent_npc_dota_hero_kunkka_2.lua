heroTalent_npc_dota_hero_kunkka_2 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_2_buff", "heroTalent/heroTalent_npc_dota_hero_kunkka_2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_kunkka_2_debuff", "heroTalent/heroTalent_npc_dota_hero_kunkka_2", LUA_MODIFIER_MOTION_NONE )


function heroTalent_npc_dota_hero_kunkka_2:Spawn()
	if IsServer() then
		local heroes = GetAllRealHeroes()
		local caster = self:GetCaster()
		for _, hero in ipairs(heroes) do
			if hero:GetUnitName()=="npc_dota_hero_tidehunter" then
				hero:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_kunkka_2_debuff", {})
				caster:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_kunkka_2_buff", {})
				local particle =  ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle, 0, hero:GetOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				local particle =  ParticleManager:CreateParticle("particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(particle, 0, caster:GetOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
				hero:EmitSound("Ability.Torrent")
				caster:EmitSound("Ability.Torrent")
			end
		end
	end
	
end

function heroTalent_npc_dota_hero_kunkka_2:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/kunkka/kunkka_torrent_base/kunkka_spell_torrent_splash_econ.vpcf", context )
end



modifier_heroTalent_npc_dota_hero_kunkka_2_buff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:RemoveOnDeath() return false end
-- function heroTalent_npc_dota_hero_kunkka_2:GetEffectName() return "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf" end



-- function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:DeclareFunctions()
--     return {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
--     }
-- end

-- function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	return 46
-- end


function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_heroTalent_npc_dota_hero_kunkka_2_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 46
end




modifier_heroTalent_npc_dota_hero_kunkka_2_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:IsDebuff()	return true end
function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return 15
end

function modifier_heroTalent_npc_dota_hero_kunkka_2_debuff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
