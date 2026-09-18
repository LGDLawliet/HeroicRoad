
LinkLuaModifier("modifier_item_hd_broken_promise_buff", "items/item_hd_broken_promise.lua", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_broken_promise_thinker", "items/item_hd_broken_promise.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_broken_promise_target", "items/item_hd_broken_promise.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_broken_promise_trigger_count", "items/item_hd_broken_promise.lua", LUA_MODIFIER_MOTION_NONE)


require("internal/timers")
item_hd_broken_promise= item_hd_broken_promise or class({})
function item_hd_broken_promise:GetIntrinsicModifierName() 
    return "modifier_item_hd_broken_promise_buff" 
end
function item_hd_broken_promise:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/items/broken_promise/effect_crimson_jugger.vpcf", context )



end


function item_hd_broken_promise:GetCustomCastErrorTarget()
	return "#DOTA_HUB_CANT_CAST_TO_TARGET"
end

function item_hd_broken_promise:CastFilterResultTarget(target)
	if IsServer() then
        -- print(target:GetHDStatusResistanceIndex())
        if target:HasModifier("modifier_item_hd_broken_promise_target") then
            return UF_FAIL_CUSTOM
        end
		return UF_SUCCESS
	end
end
function item_hd_broken_promise:Spawn()

end
function item_hd_broken_promise:OnSpellStart()
	if self.target then
		return
	end

    local target = self:GetCaster():GetCursorCastTarget()

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    DestroyParticleByDelay(particle,2)

    target:AddNewModifier(
        self:GetCaster(), -- player source
        self, -- ability source
        "modifier_item_hd_broken_promise_target", -- modifier name
        {} -- kv
    )
	self.target = target
end




modifier_item_hd_broken_promise_buff=class({})

-- function modifier_item_hd_broken_promise_buff:IsPassive()			return true end
function modifier_item_hd_broken_promise_buff:IsDebuff() return false end
function modifier_item_hd_broken_promise_buff:IsHidden() 		return true end
function modifier_item_hd_broken_promise_buff:IsPurgable() 		return false end
function modifier_item_hd_broken_promise_buff:IsPurgeException() return false end
function modifier_item_hd_broken_promise_buff:AllowIllusionDuplicate() return false end
-- function modifier_item_hd_broken_promise_buff:DestroyOnExpire() return false end
function modifier_item_hd_broken_promise_buff:OnCreated()

    local ability = self:GetAbility()
	self.bonus_str = -ability:GetSpecialValueFor("bonus_str")
    self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")

 

end
function modifier_item_hd_broken_promise_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,   
        MODIFIER_PROPERTY_MANA_BONUS,
	}
end


function modifier_item_hd_broken_promise_buff:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_broken_promise_buff:GetModifierManaBonus()	return self.bonus_mana end







modifier_item_hd_broken_promise_target = class({})
function modifier_item_hd_broken_promise_target:IsHidden()	return false end
function modifier_item_hd_broken_promise_target:IsDebuff()	return false end
function modifier_item_hd_broken_promise_target:IsPurgable()	return false end
function modifier_item_hd_broken_promise_target:RemoveOnDeath()	return false end


function modifier_item_hd_broken_promise_target:OnCreated( kv )
    if IsServer() then
        self:PlayEffects()
		self.damage_record = 0

		self.tData = {}
		-- table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:StartIntervalThink(0.1)
    end

end


function modifier_item_hd_broken_promise_target:IncreaseIndex()
	if IsServer() then
		local dieTime = GameRules:GetGameTime()+10
		table.insert(self.tData, {dieTime = dieTime })
		self:IncrementStackCount()
	end
end

function modifier_item_hd_broken_promise_target:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end




function modifier_item_hd_broken_promise_target:OnDestroy()
	if not IsServer() then return end
	DestroyParticleByDelayButNotImmediately (self.effect_cast,2)
end



function modifier_item_hd_broken_promise_target:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/rebuild/items/broken_promise/effect_crimson_jugger.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	-- ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt(self.effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

end



function modifier_item_hd_broken_promise_target:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_EVENT_ON_TAKEDAMAGE


	}
end


function modifier_item_hd_broken_promise_target:GetModifierBonusStats_Strength()	return 15 end
function modifier_item_hd_broken_promise_target:GetModifierBonusStats_Agility()	return 15 end
function modifier_item_hd_broken_promise_target:GetModifierBonusStats_Intellect()	return 15 end



function modifier_item_hd_broken_promise_target:OnTakeDamage( keys )

	if IsServer() then
		local Attacker = keys.attacker
		local Target = keys.unit

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if not self:GetAbility() then
			self:SafeDestroy()
		end


		self.damage_record = self.damage_record + keys.damage*0.2
		local needIndex = 1 + self:GetStackCount()*0.3
		if self.damage_record>=(self:GetCaster():GetMaxHealth()+1000)*needIndex then
			self.damage_record = 0
			self:IncreaseIndex()
			local particle = ParticleManager:CreateParticle("particles/rebuild/items/broken_promise/release_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin()+Vector(0,0,128))
			DestroyParticleByDelay(particle,2)
			self:GetParent():EmitSound("DOTA_Item.AbyssalBlade.Activate")


			local damageTable = {
				-- victim = target,
				attacker = self:GetCaster(),
				damage = self:GetCaster():GetMana()*0.5,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(), --Optional.
			}
	
			local enemies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				self:GetParent():GetOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				0,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)

			-- damage enemies
			for _,enemy in pairs(enemies) do
				damageTable.victim = enemy
				ApplyDamage( damageTable )

			end
		end

				

	end

	return 0.0

end