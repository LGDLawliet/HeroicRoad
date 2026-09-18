LinkLuaModifier( "modifier_Advanced_curse", "skills/Advanced_curse.lua", LUA_MODIFIER_MOTION_NONE )

Advanced_curse = class({})

function Advanced_curse:CheckKV(key)
	local table = {
		radius = 5,
		incoming = 0.4,
	}
	local value = table[key] or -1
	return value
end

function Advanced_curse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function Advanced_curse:GetManaCost()
    if self:GetAutoCastState() then
	    return self:GetSpecialValueFor("cost")
    else
        return 200
    end
end

function Advanced_curse:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf", context )
end

function Advanced_curse:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local incoming = self:GetSpecialValueFor("incoming")
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	duration = duration*ModifierStatusNegativeGain
    self.advanced_level = self:GetSpecialValueFor("advanced_level")

    if self:GetAutoCastState() then
        local delay = self:GetSpecialValueFor("delay")
        local index = 1 + self:GetSpecialValueFor("index")*0.01

        incoming = incoming*index

        EmitSoundOnLocationWithCaster(point, "Hero_WitchDoctor.Maledict_Cast", caster)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle, 0, point)
        ParticleManager:SetParticleControl(particle, 1, Vector(0, 0, 0))
        ParticleManager:DestroyParticle(particle, false) 
        
        caster:GameTimer(delay,function ()
            self:Applycurse(point,radius,duration,incoming)
        end)
    else
	    self:Applycurse(point,radius,duration,incoming)
    end
end

function Advanced_curse:Applycurse(point,radius,duration,incoming)
	local caster = self:GetCaster()
	-- 播放施法音效
	EmitSoundOnLocationWithCaster(point, "Hero_WitchDoctor.Maledict_Cast", caster)
	-- 创建巫蛊咒术特效
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	ParticleManager:DestroyParticle(particle, false)
	--ParticleManager:ReleaseParticleIndex(particle)
	
	-- 寻找范围内的敌人
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		point,
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	
	-- 对范围内的敌人施加减甲效果
	for _, enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_Advanced_curse", {incoming = incoming , duration = duration})
	end
end

----------------------------------
modifier_Advanced_curse = advanced_modifier({})

function modifier_Advanced_curse:IsHidden()return false end
function modifier_Advanced_curse:IsDebuff()return true end
function modifier_Advanced_curse:IsPurgable()return false end

function modifier_Advanced_curse:OnCreated(keys)
	if IsServer() then
		self.incoming = keys.incoming or 0
		self:SetStackCount(self.incoming)
	end
	
end

function modifier_Advanced_curse:OnRefresh(keys)
	if IsServer() then
		self.incoming = keys.incoming or 0
		self:SetStackCount(self.incoming)
	end
	
end

function modifier_Advanced_curse:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
    }
	return funcs
end

function modifier_Advanced_curse:DeclareFunctions()
    local funcs = {}
    -- lv10
    if self:GetAbility():GetSpecialValueFor("advanced_level") >= 10 then
        table.insert(funcs,MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS)
        table.insert(funcs,MODIFIER_PROPERTY_MISS_PERCENTAGE)
    end
	return funcs
end

function modifier_Advanced_curse:GetModifierProjectileSpeedBonus()
    return -200
end

function modifier_Advanced_curse:GetModifierMiss_Percentage()
    return 30
end

function modifier_Advanced_curse:OnDeath(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then
        return
    end
    if not keys.attacker then
        return
    end
    local regen = self:GetAbility():GetSpecialValueFor("regen")*0.01
    -- lv5
    if self:GetAbility().advanced_level >= 5 then
        regen = 0.1
    end
    local hp = (keys.attacker:GetMaxHealth()-keys.attacker:GetHealth())*regen
    local mp = (keys.attacker:GetMaxMana()-keys.attacker:GetMana())*regen
    if self:GetAbility().advanced_level >= 5 then
        hp = math.max(keys.attacker:GetMaxHealth()*0.03,hp)
        mp = math.max(keys.attacker:GetMaxMana()*0.03,mp)
    end
    keys.attacker:Heal(hp, self:GetAbility())
    keys.attacker:GiveMana(mp)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, keys.attacker, hp, nil) 
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, keys.attacker, mp, nil)
    -- lv15
    if self:GetAbility().advanced_level >= 15 then
        if keys.attacker ~= self:GetCaster() then
            self:GetCaster():Heal(hp, self:GetAbility())
            self:GetCaster():GiveMana(mp)
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), hp, nil) 
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetCaster(), mp, nil)
        end
    end
    -- lv20
    if self:GetAbility().advanced_level >= 20 then
        local random = math.random
        if 3 >= random(1,100) then
            self:GetAbility():Applycurse(keys.unit:GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("duration"), self:GetAbility():GetSpecialValueFor("incoming")*2.2)
        end
    end
end

function modifier_Advanced_curse:Advanced_GetModifierIncomingDamage_Percentage()
	return self:GetStackCount()
end

function modifier_Advanced_curse:GetEffectName()
	return "particles/units/heroes/hero_witchdoctor/witchdoctor_maledict_dot.vpcf"
end

function modifier_Advanced_curse:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end