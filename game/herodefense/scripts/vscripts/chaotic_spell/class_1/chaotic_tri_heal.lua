
chaotic_tri_heal = class({})
LinkLuaModifier("modifier_chaotic_tri_heal", "chaotic_spell/class_1/chaotic_tri_heal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_tri_heal_rune_3", "chaotic_spell/class_1/chaotic_tri_heal", LUA_MODIFIER_MOTION_NONE)

function chaotic_tri_heal:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", context )

end
function chaotic_tri_heal:GetIntrinsicModifierName()
	return "modifier_chaotic_tri_heal"
end

-----------------------------------------------------------
modifier_chaotic_tri_heal = advanced_modifier({})

function modifier_chaotic_tri_heal:IsHidden() return true end
function modifier_chaotic_tri_heal:IsPurgable() return false end
function modifier_chaotic_tri_heal:IsDebuff() return false end

function modifier_chaotic_tri_heal:OnCreated(keys)
	if IsServer() then
		self.cost = self:GetAbility():GetSpecialValueFor("cost") 
		self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
		self.heal = self:GetAbility():GetSpecialValueFor("heal") *0.01
        self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get") *0.01
		if self:GetAbility():GetRuneType()==3 then
			self:GetCaster():GameTimer(0.3,function ()
                self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_chaotic_tri_heal_rune_3",{})
            end)
		end
        self:StartIntervalThink(0.3)
	end
end

function modifier_chaotic_tri_heal:OnRefresh(keys)
	
	if IsServer() then
		self.cost = self:GetAbility():GetSpecialValueFor("cost") 
		self.cost_get = self:GetAbility():GetSpecialValueFor("cost_get") 
		self.heal = self:GetAbility():GetSpecialValueFor("heal") *0.01
        self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get") *0.01
	end
end

function modifier_chaotic_tri_heal:OnDestroy(keys)
	if IsServer() then
		local rune_3 = self:GetCaster():FindModifierByName("modifier_chaotic_tri_heal_rune_3")
        if rune_3 then
            rune_3:SafeDestroy()
        end
	end
end

function modifier_chaotic_tri_heal:OnIntervalThink()
    local trigger = self:GetCaster():FindModifierByName("modifier_hd_trigger")
	if trigger and trigger:GetStackCount() >= self.cost and self:GetAbility():GetAutoCastState() then
        if self:GetAbility():IsCooldownReady() then
			if self:GetParent():GetHealthPercent() >= 100 and self:GetParent():GetManaPercent() >= 100 then
				return
			end
		    self:PlayEffect(self:GetCaster())
            trigger:SetStackCount(trigger:GetStackCount() - self.cost)
            self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("cd"))
        end
    end
end

function modifier_chaotic_tri_heal:PlayEffect(unit)
	local target = unit
	
	EmitSoundOn( "Hero_Chen.PenitenceImpact", target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_chen/chen_holy_persuasion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl(effect_cast,0,target:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)
	target:EmitSound("Hero_Chen.HandOfGodHealHero")
	target:Heal(target:GetMaxHealth()*self.heal, self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, target:GetMaxHealth()*self.heal, nil)
    local mana = target:GetMaxMana()*self.mana_get
    target:GiveMana(mana)
    SendOverheadEventMessage(target, OVERHEAD_ALERT_MANA_ADD  ,target, mana, nil)
end

function modifier_chaotic_tri_heal:ADDeclareFunctions()
    local funcs = 
    {
		MODIFIER_EVENT_ON_DEATH = {nil, nil},

    }
    if self:GetAbility():GetRuneType()==1 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_HEALTH_BONUS)
    end
    if self:GetAbility():GetRuneType()==2 then
        table.insert(funcs,advanced_MODIFIER_PROPERTY_MANA_BONUS)
    end
    return funcs
end

function modifier_chaotic_tri_heal:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local attacker = keys.attacker
		
		if attacker and attacker:GetPlayerOwnerID()==self:GetParent():GetPlayerOwnerID() and IsEnemy(unit,attacker) then
			local nPlayerID = attacker:GetPlayerOwnerID()
            local player = PlayerResource:GetPlayer(nPlayerID)
            attacker:AddNewModifier(attacker,self:GetAbility(),"modifier_hd_trigger",{cost_get = self.cost_get})
		end
	end
end

function modifier_chaotic_tri_heal:AdvancedGetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor("rune_1_hp")
end
function modifier_chaotic_tri_heal:AdvancedGetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor("rune_2_mana")
end
--------------
modifier_chaotic_tri_heal_rune_3 = advanced_modifier({})

function modifier_chaotic_tri_heal_rune_3:IsHidden() return true end
function modifier_chaotic_tri_heal_rune_3:IsPurgable() return false end
function modifier_chaotic_tri_heal_rune_3:IsDebuff() return false end
function modifier_chaotic_tri_heal_rune_3:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chaotic_tri_heal_rune_3:OnCreated(keys)
	self.heal = self:GetAbility():GetSpecialValueFor("heal") *0.01
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get") *0.01
    self.rune_3_interval = self:GetAbility():GetSpecialValueFor("rune_3_interval")
	if IsServer() then
		self:StartIntervalThink(self.rune_3_interval)
	end
end

function modifier_chaotic_tri_heal_rune_3:OnRefresh(keys)
	self.heal = self:GetAbility():GetSpecialValueFor("heal") *0.01
    self.mana_get = self:GetAbility():GetSpecialValueFor("mana_get") *0.01
end

function modifier_chaotic_tri_heal_rune_3:OnIntervalThink()
	local modifier = self:GetParent():FindModifierByName("modifier_chaotic_tri_heal")
    if modifier then
        modifier:PlayEffect(self:GetParent())
    end
end