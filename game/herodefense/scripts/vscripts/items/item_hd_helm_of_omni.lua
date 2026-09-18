item_hd_helm_of_omni = class({})

LinkLuaModifier("modifier_item_hd_helm_of_omni", "items/item_hd_helm_of_omni", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_omni_active", "items/item_hd_helm_of_omni", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_helm_of_omni_debuff", "items/item_hd_helm_of_omni", LUA_MODIFIER_MOTION_NONE)

function item_hd_helm_of_omni:GetIntrinsicModifierName()
	return "modifier_item_hd_helm_of_omni"
end

require('internal/timers')   --计时器功能


function item_hd_helm_of_omni:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", context )

end



function item_hd_helm_of_omni:OnSpellStart()

	local caster    =   self:GetCaster()
	local target = self:GetCursorTarget()

	if target:HasModifier("modifier_item_hd_helm_of_omni_active") then
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"DOTA_HUB_CANT_CAST_TO_TARGET","General.Cancel")
		return
	end
	if self.modifier then
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"DOTA_HUB_CANT_CAST_TO_TARGET","General.Cancel")
		return
	end

	target:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	DestroyParticleByDelay(particle,2)
	self.modifier = target:AddNewModifier(caster, self, "modifier_item_hd_helm_of_omni_active", {})
	

end





modifier_item_hd_helm_of_omni = class({})

function modifier_item_hd_helm_of_omni:IsDebuff() return false end
function modifier_item_hd_helm_of_omni:IsHidden() return true end
function modifier_item_hd_helm_of_omni:IsPurgable() 		return false end
function modifier_item_hd_helm_of_omni:IsPurgeException() 	return false end
function modifier_item_hd_helm_of_omni:RemoveOnDeath()  return false end


function modifier_item_hd_helm_of_omni:OnCreated(keys)
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
end
function modifier_item_hd_helm_of_omni:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end


function modifier_item_hd_helm_of_omni:GetModifierHealthBonus()	return self.bonus_health end



modifier_item_hd_helm_of_omni_active = class({})

function modifier_item_hd_helm_of_omni_active:IsDebuff() return false end
function modifier_item_hd_helm_of_omni_active:IsHidden() return false end
function modifier_item_hd_helm_of_omni_active:IsPurgable() return false end
function modifier_item_hd_helm_of_omni_active:GetTexture()return "item_helm_of_omni" end
function modifier_item_hd_helm_of_omni_active:IsPurgeException() return false end
function modifier_item_hd_helm_of_omni_active:RemoveOnDeath() return false end
function modifier_item_hd_helm_of_omni_active:OnCreated(keys)
	if IsServer() then
		self.modifier = self:GetCaster():FindModifierByName("modifier_item_hd_helm_of_omni")
		if not self.modifier then
			self:SafeDestroy() 
			return
		end
		self.timer =  GameRules:GetGameTime()+30
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_helm_of_omni_active:OnIntervalThink()

	if self.modifier:IsNull() then
		local caster = self:GetCaster()
		if caster then
			local stack = self:GetStackCount()
			if not caster:IsAlive() then
				-- 以防死亡加不上buff
				Timers:CreateTimer(1, function()
					if not caster:IsAlive() then
						return 1
					end
					caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_helm_of_omni_debuff", {stack = stack})
					
				end)
			else
				caster:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_helm_of_omni_debuff", {stack = stack})
			end
			
		end
		self:SafeDestroy()

		return
	end
	if GameRules:GetGameTime()>=self.timer then
		self.timer =  GameRules:GetGameTime()+30
		self:SetStackCount(math.min(self:GetStackCount()+1,50))
		local target = self:GetParent()
		target:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		DestroyParticleByDelay(particle,2)
	end
end


function modifier_item_hd_helm_of_omni_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_helm_of_omni_active:GetModifierBonusStats_Strength()	return self:GetStackCount() end
function modifier_item_hd_helm_of_omni_active:GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_item_hd_helm_of_omni_active:GetModifierBonusStats_Agility()	return self:GetStackCount() end








modifier_item_hd_helm_of_omni_debuff = class({})

function modifier_item_hd_helm_of_omni_debuff:IsDebuff() return true end
function modifier_item_hd_helm_of_omni_debuff:IsHidden() return false end
function modifier_item_hd_helm_of_omni_debuff:IsPurgable() return false end
function modifier_item_hd_helm_of_omni_debuff:GetTexture()return "item_helm_of_omni" end
function modifier_item_hd_helm_of_omni_debuff:IsPurgeException() return false end
function modifier_item_hd_helm_of_omni_debuff:RemoveOnDeath() return false end
function modifier_item_hd_helm_of_omni_debuff:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.stack)
		local target = self:GetParent()
		target:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		DestroyParticleByDelay(particle,2)
	end
end
function modifier_item_hd_helm_of_omni_debuff:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+keys.stack)
		local target = self:GetParent()
		target:EmitSound("Hero_Omniknight.HammerOfPurity.Target")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_shard_hammer_of_purity_target.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		DestroyParticleByDelay(particle,2)
	end
end



function modifier_item_hd_helm_of_omni_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_item_hd_helm_of_omni_debuff:GetModifierBonusStats_Strength()	return -self:GetStackCount() end
function modifier_item_hd_helm_of_omni_debuff:GetModifierBonusStats_Intellect()	return -self:GetStackCount() end
function modifier_item_hd_helm_of_omni_debuff:GetModifierBonusStats_Agility()	return -self:GetStackCount() end