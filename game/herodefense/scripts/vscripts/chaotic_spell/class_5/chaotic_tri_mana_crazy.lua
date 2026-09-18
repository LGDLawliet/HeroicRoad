
chaotic_tri_mana_crazy = class({})
LinkLuaModifier("modifier_chaotic_tri_mana_crazy", "chaotic_spell/class_5/chaotic_tri_mana_crazy", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_mana_crazy_buff", "chaotic_spell/class_5/chaotic_tri_mana_crazy", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_mana_crazy:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", context )

end
function chaotic_tri_mana_crazy:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_mana_crazy"
end

-----------------------------------------------------------
modifier_chaotic_tri_mana_crazy = advanced_modifier({})

function modifier_chaotic_tri_mana_crazy:IsHidden() return true end
function modifier_chaotic_tri_mana_crazy:IsPurgable() return false end
function modifier_chaotic_tri_mana_crazy:IsDebuff() return false end

function modifier_chaotic_tri_mana_crazy:OnCreated(keys)
	
	self.cost = self:GetAbility():GetSpecialValueFor("cost") 
	self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get")
	self.line = self:GetAbility():GetSpecialValueFor("line")
	if self:GetAbility():GetRuneType()==3 then

	end
	if IsServer() then
        self:StartIntervalThink(0.3)
	end
end

function modifier_chaotic_tri_mana_crazy:OnRefresh(keys)
	self.cost = self:GetAbility():GetSpecialValueFor("cost") 
	self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get")
	self.line = self:GetAbility():GetSpecialValueFor("line")
end

function modifier_chaotic_tri_mana_crazy:OnDestroy(keys)
	if IsServer() then

	end
end

function modifier_chaotic_tri_mana_crazy:OnIntervalThink()
    local trigger = self:GetCaster():FindModifierByName("modifier_hd_trigger")
	if trigger and trigger:GetStackCount() >= self.cost and self:GetAbility():GetAutoCastState() then
        if self:GetAbility():IsCooldownReady() then
			if self:GetAbility():GetRuneType() == 2 then

				local mana = self.mana_get * self:GetCaster():GetIntellect(false)*0.5
				if self:GetParent():GetMana() < mana then
					return
				end
				self:PlayEffect(self:GetCaster())
				trigger:SetStackCount(trigger:GetStackCount() - self.cost)
				local cd = self:GetAbility():GetSpecialValueFor("cooldown")
				if self:GetAbility():GetRuneType() == 1 then
					cd = cd* (1+self:GetAbility():GetSpecialValueFor("rune_1_cooldown")*0.01)
				end
            	self:GetAbility():StartCooldown(cd)

			else

				if self:GetParent():GetManaPercent() >= self.line then
					return
				end
		   	 	self:PlayEffect(self:GetCaster())
				trigger:SetStackCount(trigger:GetStackCount() - self.cost)
				local cd = self:GetAbility():GetSpecialValueFor("cooldown")
				if self:GetAbility():GetRuneType() == 1 then
					cd = cd* (1+self:GetAbility():GetSpecialValueFor("rune_1_cooldown")*0.01)
				end
            	self:GetAbility():StartCooldown(cd)
			end 
        end
    end
end

function modifier_chaotic_tri_mana_crazy:PlayEffect(unit)
	if not IsServer() then return end
	local target = unit
	
	target:EmitSound("Hero_Antimage.ManaVoidCast")
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_mana_loss.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(self.particle, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.particle)

	local mana = self.mana_get * self:GetCaster():GetIntellect(false)

	if self:GetAbility():GetRuneType() == 1 then
		mana = self.mana_get * self:GetCaster():HDGetPrimaryStatValue()* (1+self:GetAbility():GetSpecialValueFor("rune_1_mana_get")*0.01)
	end

	if self:GetAbility():GetRuneType() == 2 then
		target:Script_ReduceMana(mana,self:GetAbility())
		SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_LOSS  ,target, mana, nil)
	else
		if self:GetAbility():GetRuneType() == 3 then
			target:GameTimer(1,function ()
				target:GiveMana(0.25*mana)
    			SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, 0.25*mana, nil)
			end)

			target:GameTimer(2,function ()
				target:GiveMana(0.25*mana)
    			SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, 0.25*mana, nil)
			end)

			target:GameTimer(3,function ()
				target:GiveMana(0.25*mana)
    			SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, 0.25*mana, nil)
			end)

			target:GameTimer(4,function ()
				target:GiveMana(0.25*mana)
    			SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, 0.25*mana, nil)
			end)
		else
    		target:GiveMana(mana)
    		SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, mana, nil)
		end
	end

	local gain = self:GetCaster():GetModifierDurationGainIndex(1)
	target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_chaotic_tri_mana_crazy_buff",{duration = self.duration*gain})
end

function modifier_chaotic_tri_mana_crazy:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}
end

function modifier_chaotic_tri_mana_crazy:OnAbilityExecuted(keys)
	if not IsServer() then return end
	if keys.unit ~= self:GetParent() then return end
	local ability = keys.ability
	-- 不能是物品，不能是切换类
	if ability ~= nil and ( not ability:IsItem() ) and ( not ability:IsToggle() ) and ability:GetCooldown(ability:GetLevel()) > 1 then

		local cost_get = self.cost_get * ability:GetManaCost(-1)
		keys.unit:AddNewModifier(keys.unit,self:GetAbility(),"modifier_hd_trigger",{cost_get = cost_get})

		
	end
end

--------------
modifier_chaotic_tri_mana_crazy_buff = advanced_modifier({})

function modifier_chaotic_tri_mana_crazy_buff:IsHidden() return false end
function modifier_chaotic_tri_mana_crazy_buff:IsPurgable() return false end
function modifier_chaotic_tri_mana_crazy_buff:IsDebuff() return false end
function modifier_chaotic_tri_mana_crazy_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_tri_mana_crazy_buff:OnCreated(keys)
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	if self:GetAbility():GetRuneType() == 2 then
		self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp") * (1+self:GetAbility():GetSpecialValueFor("rune_2_spell_amp")*0.01)
	end
end

function modifier_chaotic_tri_mana_crazy_buff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
	}
end

function modifier_chaotic_tri_mana_crazy_buff:Advanced_GetModifierSpellAmplifyBonus()
	return self.spell_amp
end
