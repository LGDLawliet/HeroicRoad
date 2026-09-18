

modifier_chaotic_players_1 = advanced_modifier({})

function modifier_chaotic_players_1:IsHidden()return false end
function modifier_chaotic_players_1:IsDebuff()return false end
function modifier_chaotic_players_1:IsPurgable()return false end
function modifier_chaotic_players_1:GetTexture() return "roshan_bash" end
function modifier_chaotic_players_1:IsPurgeException() 	return false end
function modifier_chaotic_players_1:RemoveOnDeath() return false end
function modifier_chaotic_players_1:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(3)
		self:StartIntervalThink(10)
	end
end
function modifier_chaotic_players_1:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_SPECIAL_Reincarnate = {nil,self:GetParent()},
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
    }
end
function modifier_chaotic_players_1:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	-- local target = keys.target
	-- if target and not target:IsNull() then
	-- 	target:ModifyHealth(0, nil, true, 0)
	-- 	print("正确触发斩杀")
	-- end
	return 240
end

function modifier_chaotic_players_1:OnTakeDamage(tg)
    if IsServer() then   
		local Ability = tg.inflictor
		local attacker = tg.attacker
		local parent = self:GetParent()

		if attacker ~= parent then return end
        
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION  then return end
		if bit.band( tg.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then return end

		-- 受吸血增强影响
        local life_steal_gain = attacker:GetModifierLifeStealGain(1)
		local hp = tg.damage *0.05 *life_steal_gain
		if tg.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			hp = hp*2
		end

		if hp <= 0 then return end

		if Ability then
			local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		else
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, tg.attacker )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		end
        attacker:Heal(hp, nil)
    end 
end

function modifier_chaotic_players_1:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
        unit:AddNewModifier(self:GetParent(), nil, "modifier_chaotic_players_1", {})
	end
end
function modifier_chaotic_players_1:OnIntervalThink()
	local parent = self:GetParent()
	if not parent:IsAlive() then
		return
	end
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_purification_cast.vpcf"
	local particle_cast_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle_cast_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_cast_fx, 1, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)
	parent:Purge(false, true, false, false,true)
end

function modifier_chaotic_players_1:AdvancedGetModifierReincarnate(keys)
	if self:GetStackCount()>=1 and self:GetParent():IsHero() then
		local data = {
			modifier = self,
			time = 3,
			priority = 1,
			invulnerable_time = 2,
		}
		return data
    end
	return nil
end

function modifier_chaotic_players_1:OnReincarnateTrigger(keys)
	self:DecrementStackCount()
end
