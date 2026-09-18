--特效优化 √
Advanced_Poison_Nova = class({})

LinkLuaModifier("modifier_Advanced_Poison_Nova", "skills/Advanced_Poison_Nova", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Poison_Nova_unlock2", "skills/Advanced_Poison_Nova", LUA_MODIFIER_MOTION_NONE)
function Advanced_Poison_Nova:CheckKV(key)
	local table = {
		poison = 15,
		bonus_poison = 0.2,
	}

	local value = table[key] or -1
	return value
end

function Advanced_Poison_Nova:UnlockFirstCore(key)
	return true
end
function Advanced_Poison_Nova:UnlockSecondCore(key)
	return true
end
function Advanced_Poison_Nova:UnlockThirdCore(key)
	return true
end


function Advanced_Poison_Nova:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/poison_nova/unlock1/effect.vpcf", context )
end

function Advanced_Poison_Nova:IsHiddenWhenStolen() 	return false end
function Advanced_Poison_Nova:IsRefreshable() 		return true end
function Advanced_Poison_Nova:IsStealable() 			return true end
function Advanced_Poison_Nova:IsNetherWardStealable()return true end
function Advanced_Poison_Nova:GetCastRange() 
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function Advanced_Poison_Nova:OnSpellStart()
	local caster = self:GetCaster()
	self:Nova(caster,caster:GetAbsOrigin(),100,1)
end

function Advanced_Poison_Nova:Nova(iparent,point,pct,trigger)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")*pct*0.01
	local duration = self:GetSpecialValueFor("duration")
	self:PlayEffects(iparent,radius)
	-- 施加debuff
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		local poison = self:GetSpecialValueFor("poison") + self:GetSpecialValueFor("bonus_poison")*caster:HDGetPrimaryStatValue()
		local index = self:GetSpecialValueFor("index")*0.01
		-- lv5
		if self.advanced_level >= 5 then
			index = 0.7	
		end
		local spell_amp = math.max(1+caster:GetSpellAmplification(false)*index,0)
		poison = poison*spell_amp
		if enemy:HasModifier("modifier_hd_poison") then
			local index_2 = (1+self:GetSpecialValueFor("index_2")*0.01)
			-- lv15
			if self.advanced_level >= 15 then
				index_2 = 1.3
			end
			poison = poison*index_2
		end
		if trigger==1 then
			enemy:AddNewModifier(caster, self, "modifier_Advanced_Poison_Nova", {duration = duration})
		end
		enemy:Poison(caster,self,poison)
	end
end

function Advanced_Poison_Nova:PlayEffects(iparent,radius)
	-- 特效
	if not IsServer() then return end
	
	local caster = iparent
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:EmitSound("Hero_Venomancer.PoisonNova")
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)

	local name = "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf"
	-- if self.unlock1 then
	-- 	name = "particles/rebuild/spell/poison_nova/unlock1/effect.vpcf"
	-- end
	local pfx2 = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx2, 1, Vector(radius, 1.5, radius))
	ParticleManager:ReleaseParticleIndex(pfx2)
	local pfx3 = ParticleManager:CreateParticle(name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(pfx3, 1, Vector(radius, 1, radius/2))
	ParticleManager:ReleaseParticleIndex(pfx3)
end



modifier_Advanced_Poison_Nova = advanced_modifier({})

function modifier_Advanced_Poison_Nova:IsDebuff()			return true end
function modifier_Advanced_Poison_Nova:IsHidden() 			return false end
function modifier_Advanced_Poison_Nova:IsPurgable() 		return false end
function modifier_Advanced_Poison_Nova:IsPurgeException() 	return false end
function modifier_Advanced_Poison_Nova:GetEffectName() return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf" end
function modifier_Advanced_Poison_Nova:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Poison_Nova:GetStatusEffectName() return "particles/status_fx/status_effect_poison_venomancer.vpcf" end
function modifier_Advanced_Poison_Nova:StatusEffectPriority() return 15 end
function modifier_Advanced_Poison_Nova:IsPoisonDeBuff() return true end

function modifier_Advanced_Poison_Nova:OnCreated()
	self.poison_res = self:GetAbility():GetSpecialValueFor("poison_res")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Venomancer.PoisonNovaImpact")
	end
end

function modifier_Advanced_Poison_Nova:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
	}
end

function modifier_Advanced_Poison_Nova:Advanced_GetModifierIncomingPoisonDamagePercentage()
	return self.poison_res
end

function modifier_Advanced_Poison_Nova:OnDeath(keys)
	if not IsServer() then return end
	if self:GetParent() ~= keys.unit then return end
	if self:GetAbility().advanced_level < 10 then return end
	-- lv10
	if not self:GetAbility():IsCooldownReady() then
		local newcooldown = (self:GetAbility():GetCooldownTimeRemaining() - 1)
		self:GetAbility():EndCooldown()
		self:GetAbility():StartCooldown(newcooldown)
	end
	if self:GetAbility().advanced_level < 20 then return end
	-- lv20
	if self:GetAbility() then
		self:GetAbility():Nova(self:GetParent(),self:GetParent():GetAbsOrigin(), 15,false)
	end
	
end