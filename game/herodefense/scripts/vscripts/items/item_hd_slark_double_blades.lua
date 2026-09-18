item_hd_slark_double_blades = class({})

LinkLuaModifier("modifier_item_hd_slark_double_blades", "items/item_hd_slark_double_blades", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slark_double_blades_buff", "items/item_hd_slark_double_blades", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_slark_double_blades_debuff", "items/item_hd_slark_double_blades", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
require('internal/timers')   --计时器功能
function item_hd_slark_double_blades:GetIntrinsicModifierName()
	return "modifier_item_hd_slark_double_blades"
end
function item_hd_slark_double_blades:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context )

end



modifier_item_hd_slark_double_blades = class({})

function modifier_item_hd_slark_double_blades:IsDebuff() return false end
function modifier_item_hd_slark_double_blades:IsHidden() return true end
function modifier_item_hd_slark_double_blades:IsPurgable() return false end

function modifier_item_hd_slark_double_blades:OnCreated(keys)
   local ability = self:GetAbility()
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi")
end



function modifier_item_hd_slark_double_blades:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,   
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK     
	}
end


function modifier_item_hd_slark_double_blades:GetModifierBonusStats_Agility()	return self.bonus_agi end
function modifier_item_hd_slark_double_blades:GetModifierProcAttack_Feedback( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:GetParent():IsInSpecialAttack() then
			return
		end
		if not self:GetParent():IsRealHero() then
			return false
		end
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		self:PlayEffects( params.target )
        caster:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_slark_double_blades_buff",{	duration = 30*caster:GetModifierDurationGainIndex(1)})
		params.target:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_slark_double_blades_debuff",{	duration = 30})





	end
end


function modifier_item_hd_slark_double_blades:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_slark/slark_essence_shift.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end









modifier_item_hd_slark_double_blades_buff = class({})

function modifier_item_hd_slark_double_blades_buff:IsHidden()	return false end
function modifier_item_hd_slark_double_blades_buff:IsDebuff()	return false end
function modifier_item_hd_slark_double_blades_buff:IsPurgable()	return false end
function modifier_item_hd_slark_double_blades_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_item_hd_slark_double_blades_buff:GetModifierPreAttack_BonusDamage()	return self:GetStackCount() end


function modifier_item_hd_slark_double_blades_buff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:SetStackCount(2)
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_slark_double_blades_buff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>=400 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })
		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:SetStackCount(math.min(self:GetStackCount()+2,400))
		end
	end
end

function modifier_item_hd_slark_double_blades_buff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:SetStackCount(self:GetStackCount()-2)
			end
		end
	end
end














modifier_item_hd_slark_double_blades_debuff = class({})

function modifier_item_hd_slark_double_blades_debuff:IsHidden()	return false end
function modifier_item_hd_slark_double_blades_debuff:IsDebuff()	return true end
function modifier_item_hd_slark_double_blades_debuff:IsPurgable()	return false end
function modifier_item_hd_slark_double_blades_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_item_hd_slark_double_blades_debuff:GetModifierPreAttack_BonusDamage()	return -self:GetStackCount() end


function modifier_item_hd_slark_double_blades_debuff:OnCreated(params)
	self.ability = self:GetAbility()
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, { dieTime = self:GetDieTime() })
		self:SetStackCount(2)
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_hd_slark_double_blades_debuff:OnRefresh(params)
	if IsServer() then
		local dieTime = self:GetDieTime()

		
		if self:GetStackCount()>=100 then
			--移除第一个 添加一个
			table.remove(self.tData, 1)
			table.insert(self.tData, {dieTime = dieTime })
		else
			--当叠加乘数没达到最高时
			table.insert(self.tData, {dieTime = dieTime })
			self:SetStackCount(math.min(self:GetStackCount()+2,400))
		end
	end
end

function modifier_item_hd_slark_double_blades_debuff:OnIntervalThink()
	if IsServer() then
		-- local hParent = self:GetParent()
		local fGameTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fGameTime >= self.tData[i].dieTime then
				table.remove(self.tData, i)
				self:SetStackCount(self:GetStackCount()-2)
			end
		end
	end
end
