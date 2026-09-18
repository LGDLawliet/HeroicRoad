LinkLuaModifier("modifier_Primary_morph", "skills/Primary_morph", LUA_MODIFIER_MOTION_NONE)

Primary_morph =  Primary_morph or class({})


function Primary_morph:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/morph/effect.vpcf", context )
end


function Primary_morph:OnUpgrade()
	if self:GetCaster():IsIllusion() and self:GetCaster():GetPlayerOwner() and self:GetCaster():GetPlayerOwner():GetAssignedHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():IsRealHero() and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()) and self:GetCaster():GetPlayerOwner():GetAssignedHero():FindAbilityByName(self:GetName()):GetToggleState() and not self:GetToggleState() then
		self:ToggleAbility()
	end
end


function Primary_morph:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Primary_morph:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Primary_morph:OnToggle()
	if not IsServer() then return end
	if self:GetCaster():GetPrimaryAttribute() == DOTA_ATTRIBUTE_ALL then
		return
	end
	if self:GetToggleState() then
		local modifier = self:GetCaster():FindModifierByName("modifier_Primary_morph")
		if modifier then
			if self:GetAutoCastState() then
				modifier:SetType(true)
			else
				modifier:SetType(false)
			end
		end
	else
		local modifier = self:GetCaster():FindModifierByName("modifier_Primary_morph")
		if modifier then
			modifier:EndChanging()
		end
	end
	
end

function Primary_morph:GetIntrinsicModifierName()
	return "modifier_Primary_morph"
end

modifier_Primary_morph	=  modifier_Primary_morph or class({})

function modifier_Primary_morph:IsHidden()	return true end
function modifier_Primary_morph:IsDebuff() return false end
function modifier_Primary_morph:RemoveOnDeath() return false end
function modifier_Primary_morph:IsPurgable() return false end
function modifier_Primary_morph:SetType(auto)
	self.back = auto
	self.parimary_attribute = self:GetParent():GetPrimaryAttribute()
	self.max_bonus = self:GetAbility():GetSpecialValueFor("change_max")
	if self.origin_parimary_attribute~= self.parimary_attribute then
		self:ResetAttribute()
		self.origin_parimary_attribute= self.parimary_attribute

	end
	local color = Vector(0,0,0)
	if self:GetAbility():GetAutoCastState() then
		color = Vector(255,255,255)
	elseif self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH then
		color = Vector(255,167,167)
	elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY then
		color = Vector(197,255,167)
	else
		color = Vector(167,167,255)
	end
	self:PlayEffect(color)
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("rate"))
end
function modifier_Primary_morph:EndChanging()
	self:StartIntervalThink(-1)
	ParticleManager:DestroyParticle(self.nFXIndex, false)
	self.nFXIndex = nil
end
function modifier_Primary_morph:PlayEffect(color)
	if self.nFXIndex then
		ParticleManager:SetParticleControl( self.nFXIndex, 60, color )
		return
	end
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/morph/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.nFXIndex, 60, color )
	ParticleManager:SetParticleControl( self.nFXIndex, 61, Vector(1,0,0) )
	self:AddParticle( self.nFXIndex, false, false, -1, true, false )
end

function modifier_Primary_morph:OnCreated(keys)
	
	if IsServer() then
		self.origin_parimary_attribute = self:GetParent():GetPrimaryAttribute()
		self.max_bonus = self:GetAbility():GetSpecialValueFor("change_max")
		self.bonus = 0
		self.bonus_str = 0
		self.bonus_agi = 0
		self.bonus_int = 0
		self.change_rate = self:GetAbility():GetSpecialValueFor("change_rate")*0.01
		self.bonus_attribute =  self:GetAbility():GetSpecialValueFor("bonus_attribute")
	end
end
function modifier_Primary_morph:OnRefresh(keys)
	if IsServer() then
		self.max_bonus = self:GetAbility():GetSpecialValueFor("change_max")
		local new_rate = self:GetAbility():GetSpecialValueFor("change_rate")*0.01
		if new_rate~=self.change_rate then
			self:ResetAttribute()
		end
		self.change_rate = new_rate
		self.bonus_attribute =  self:GetAbility():GetSpecialValueFor("bonus_attribute")
	end
end
function modifier_Primary_morph:OnDestroy()
	if IsServer() then
		self:ResetAttribute()
	end
end
function modifier_Primary_morph:OnIntervalThink()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	if self.back then --逆转
		--看看扣除的属性是否大过最高奖励
		if -self.bonus>=self.max_bonus then
			ability:ToggleAbility()
			return
		end
		if self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH  then
			--主属性是力量  抽取智力与敏捷
			if self:CheckSubAttribute(true,false,false) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self.bonus_str = self.bonus_str - 1
				self.bonus = self.bonus - 1
				self.bonus_agi = self.bonus_agi+gain
				self.bonus_int = self.bonus_int +gain
			else
				ability:ToggleAbility()
				return
			end
		elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY  then
			--主属性是敏捷  抽取力量与智力
			if self:CheckSubAttribute(false,true,false) then
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self.bonus_agi = self.bonus_agi - 1
				self.bonus = self.bonus - 1
				self.bonus_str = self.bonus_str+gain
				self.bonus_int = self.bonus_int +gain
			else
				ability:ToggleAbility()
				return
			end
		else
			--主属性是智力  抽取力量与敏捷
			if self:CheckSubAttribute(false,false,true) then
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 1/self.change_rate*0.5
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				self.bonus_int = self.bonus_int - 1
				self.bonus = self.bonus - 1
				self.bonus_str = self.bonus_str+gain
				self.bonus_agi = self.bonus_agi +gain
			else
				ability:ToggleAbility()
				return
			end
		end
	else
		--超过最大转化值了
		if self.bonus>=self.max_bonus then
			ability:ToggleAbility()
			return
		end
		if self.parimary_attribute==DOTA_ATTRIBUTE_STRENGTH  then
			--主属性是力量  抽取智力与敏捷
			if self:CheckSubAttribute(false,true,true) then
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseStrength(parent:GetBaseStrength()+gain)
				self.bonus_str = self.bonus_str + gain
				self.bonus = self.bonus + gain
				self.bonus_agi = self.bonus_agi - 1
				self.bonus_int = self.bonus_int - 1

			else
				ability:ToggleAbility()
				return
			end
		elseif self.parimary_attribute==DOTA_ATTRIBUTE_AGILITY  then
			--主属性是敏捷  抽取力量与智力
			if self:CheckSubAttribute(true,false,true) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				parent:SetBaseIntellect(parent:GetBaseIntellect()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseAgility(parent:GetBaseAgility()+gain)
				self.bonus_agi = self.bonus_agi + gain
				self.bonus = self.bonus + gain
				self.bonus_str = self.bonus_str - 1
				self.bonus_int = self.bonus_int - 1

			else
				ability:ToggleAbility()
				return
			end
		else
			if self:CheckSubAttribute(true,true,false) then
				parent:SetBaseStrength(parent:GetBaseStrength()-1)
				parent:SetBaseAgility(parent:GetBaseAgility()-1)
				local gain = 2 * self.change_rate
				parent:SetBaseIntellect(parent:GetBaseIntellect()+gain)
				self.bonus_int = self.bonus_int + gain
				self.bonus = self.bonus + gain
				self.bonus_str = self.bonus_str - 1
				self.bonus_agi = self.bonus_agi - 1

			else
				ability:ToggleAbility()
				return
			end
		end
	end
end
function modifier_Primary_morph:ResetAttribute()
	local parent = self:GetParent()
	parent:SetBaseStrength(parent:GetBaseStrength()-self.bonus_str)
	parent:SetBaseAgility(parent:GetBaseAgility()-self.bonus_agi)
	parent:SetBaseIntellect(parent:GetBaseIntellect()-self.bonus_int)
	self.bonus = 0
	self.bonus_str = 0
	self.bonus_agi = 0
	self.bonus_int = 0
end

function modifier_Primary_morph:CheckSubAttribute(str,agi,int)
	local parent = self:GetParent()
	if str then
		local strength = parent:GetBaseStrength()
		if strength<=1 then
			return false
		end
	end
	if agi then
		local agility = parent:GetBaseAgility()
		if agility<=1 then
			return false
		end
	end

	if int then
		local intellect = parent:GetBaseIntellect()
		if intellect<=1 then
			return false
		end
	end
	return true
end


function modifier_Primary_morph:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
	}
end


function modifier_Primary_morph:GetModifierBonusStats_Strength()	
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_STRENGTH  then
			return self.bonus_attribute 
		end
	end
	
end
function modifier_Primary_morph:GetModifierBonusStats_Intellect()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_INTELLECT  or self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_ALL  then
			return self.bonus_attribute 
		end
	end
end
function modifier_Primary_morph:GetModifierBonusStats_Agility()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_AGILITY   then
			return self.bonus_attribute 
		end
	end
end