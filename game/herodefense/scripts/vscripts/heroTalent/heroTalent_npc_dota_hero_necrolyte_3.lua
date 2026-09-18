heroTalent_npc_dota_hero_necrolyte_3 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte_3", "heroTalent/heroTalent_npc_dota_hero_necrolyte_3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown", "heroTalent/heroTalent_npc_dota_hero_necrolyte_3", LUA_MODIFIER_MOTION_NONE )

-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_necrolyte_3:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_necrolyte_3"
end
function heroTalent_npc_dota_hero_necrolyte_3:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/talent/necrolyte_3/effect.vpcf" , context )
end



function heroTalent_npc_dota_hero_necrolyte_3:GetReapers_Scythe()
	if not self.ability then
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Reapers_Scythe")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Reapers_Scythe")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Reapers_Scythe")
			end
		end
	else
		if self.ability:IsNull() then
			self.ability = self:GetCaster():FindAbilityByName("Advanced_Reapers_Scythe")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Middle_Reapers_Scythe")
				if not self.ability then
					self.ability = self:GetCaster():FindAbilityByName("Primary_Reapers_Scythe")
				end
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end

function heroTalent_npc_dota_hero_necrolyte_3:Spawn()
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
				skillshop:LearnTalentDefaultAbility(caster,"Reapers_Scythe",costKeys)
			end
		end)
	
	end

end





modifier_heroTalent_npc_dota_hero_necrolyte_3 = class({})

function modifier_heroTalent_npc_dota_hero_necrolyte_3:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:RemoveOnDeath() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:GetEffectName() return "particles/rebuild/talent/necrolyte_3/effect.vpcf" end
function modifier_heroTalent_npc_dota_hero_necrolyte_3:OnCreated(table)
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.chance_plus = self:GetAbility():GetSpecialValueFor("chance_plus")
	self.index = self:GetAbility():GetSpecialValueFor("index")*0.01
end

function modifier_heroTalent_npc_dota_hero_necrolyte_3:DeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE
		
	}
end

function modifier_heroTalent_npc_dota_hero_necrolyte_3:OnTakeDamage(keys)
	if IsServer() then   
		local attacker = keys.attacker
		local unit = keys.unit
		if not unit then return end
		if not attacker then
			return
		end
		if attacker~=self:GetParent() then	return end
		if keys.damage<=10 then return	end
		if attacker:PassivesDisabled() then
			return
		end
		if unit:HasModifier("modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown") then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		local chance = self.chance
		if keys.damage>=unit:GetMaxHealth()*self.chance_plus*0.01 then
			chance = self.chance_plus
		end
		if unit:IsAlive() then
			if attacker:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
				local ability = self:GetAbility():GetReapers_Scythe()
				if ability then
					attacker:AddNewModifier(attacker, self:GetAbility(), "modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown", {duration = 1})
					ability:Reap(unit,self.index)
				end
			end
		end



    end 
end




modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown = class({})

function modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_necrolyte_3_cooldown:RemoveOnDeath() return false end