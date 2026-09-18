
Primary_Refraction = Primary_Refraction or class({})
LinkLuaModifier( "modifier_Primary_Refraction_buff_block", "skills/Primary_Refraction", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_Refraction_buff_attribute", "skills/Primary_Refraction", LUA_MODIFIER_MOTION_NONE )

function Primary_Refraction:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", context )

end


function Primary_Refraction:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster,self,"modifier_Primary_Refraction_buff_block",{	duration = duration})
	caster:AddNewModifier(caster,self,"modifier_Primary_Refraction_buff_attribute",{	duration = duration})
	caster:EmitSound("Hero_TemplarAssassin.Refraction")
	caster:StartGesture(ACT_DOTA_CAST_REFRACTION)
end

function Primary_Refraction:PlayEffects()
	if self.effect_cast then
		return
	end
	local caster = self:GetCaster()
	
	local particle_cast = "particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf"
	local effect = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(effect,0,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true )
	ParticleManager:SetParticleControlEnt(effect,1,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect,5,caster,PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true )
	
	self.effect_cast = effect
end
function Primary_Refraction:DestroySpellParticle(type)
	local caster = self:GetCaster()
	if type==1 then
		if caster:HasModifier("modifier_Primary_Refraction_buff_attribute") then
			return
		end
	else
		if caster:HasModifier("modifier_Primary_Refraction_buff_block") then
			return
		end
	end
	if self.effect_cast then
		ParticleManager:DestroyParticle(self.effect_cast,false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end

end



modifier_Primary_Refraction_buff_block =modifier_Primary_Refraction_buff_block or advanced_modifier({})
function modifier_Primary_Refraction_buff_block:IsHidden()	return false end
function modifier_Primary_Refraction_buff_block:IsDebuff()	return false end
function modifier_Primary_Refraction_buff_block:IsPurgable()	return true end
function modifier_Primary_Refraction_buff_block:OnCreated( kv )
	if not IsServer() then return end
	local stack = self:GetAbility():GetSpecialValueFor( "instances" )
	self:SetStackCount( stack )
	self:GetAbility():PlayEffects()
end

function modifier_Primary_Refraction_buff_block:OnRefresh( kv )
	if not IsServer() then return end
	local stack = self:GetAbility():GetSpecialValueFor( "instances" )
	self:SetStackCount( stack )
end
function modifier_Primary_Refraction_buff_block:OnDestroy( kv )
	if not IsServer() then return end
	self:GetAbility():DestroySpellParticle(1)

end





function modifier_Primary_Refraction_buff_block:ADDeclareFunctions()
	return {
		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_LOW_LEVEL = {nil, self:GetParent()},
	}
end


function modifier_Primary_Refraction_buff_block:AdvancedGetModifierTotal_ConstantBlock_LowLevel(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled and not self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
        return 0 
    end
	if keys.damage<=20 then
		return 0
	end

	if self:GetStackCount()>=1 then
		self:DecrementStackCount()
		if keys.damage>=self:GetParent():GetMaxHealth()*0.5 and not self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
			return keys.damage *0.7
		end
		return keys.damage
	else
		self:SafeDestroy()
		return 0
	end


end




modifier_Primary_Refraction_buff_attribute =modifier_Primary_Refraction_buff_attribute or class({})
function modifier_Primary_Refraction_buff_attribute:IsHidden()	return false end
function modifier_Primary_Refraction_buff_attribute:IsDebuff()	return false end
function modifier_Primary_Refraction_buff_attribute:IsPurgable()	return true end
function modifier_Primary_Refraction_buff_attribute:OnCreated( kv )
	if IsServer() then
		self.bonus_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")
		if self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
			self.bonus_attribute = 2*self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
	end
end
function modifier_Primary_Refraction_buff_attribute:OnRefresh( kv )
	if IsServer() then
		self.bonus_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")
		if self:GetCaster():FindModifierByName("modifier_heroTalent_npc_dota_hero_templar_assassin") then
			self.bonus_attribute = 2*self:GetAbility():GetSpecialValueFor("bonus_attribute")
		end
	end
end

function modifier_Primary_Refraction_buff_attribute:OnDestroy( kv )
	if not IsServer() then return end
	self:GetAbility():DestroySpellParticle(2)

end

function modifier_Primary_Refraction_buff_attribute:DeclareFunctions()
	local funcs ={
		MODIFIER_PROPERTY_TOOLTIP
	}
	if IsServer()  then
		local attribute = self:GetParent():GetPrimaryAttribute()
		if attribute==DOTA_ATTRIBUTE_STRENGTH  then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		elseif attribute==DOTA_ATTRIBUTE_AGILITY  then
			table.insert(funcs,MODIFIER_PROPERTY_STATS_AGILITY_BONUS )
		else
			table.insert(funcs,MODIFIER_PROPERTY_STATS_INTELLECT_BONUS  )
		end
	end
	return funcs
end


function modifier_Primary_Refraction_buff_attribute:GetModifierBonusStats_Strength()	return self.bonus_attribute end
function modifier_Primary_Refraction_buff_attribute:GetModifierBonusStats_Agility()	return self.bonus_attribute end
function modifier_Primary_Refraction_buff_attribute:GetModifierBonusStats_Intellect()	return self.bonus_attribute end

function modifier_Primary_Refraction_buff_attribute:OnTooltip()
    return self.bonus_attribute 
end
