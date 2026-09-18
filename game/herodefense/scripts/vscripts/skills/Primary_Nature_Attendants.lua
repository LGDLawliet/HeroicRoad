Primary_Nature_Attendants = class({})
LinkLuaModifier("modifier_Primary_Nature_Attendants_hp", "skills/Primary_Nature_Attendants", LUA_MODIFIER_MOTION_NONE)



function Primary_Nature_Attendants:IsHiddenWhenStolen()        return false end
function Primary_Nature_Attendants:IsStealable()               return true end
function Primary_Nature_Attendants:IsRefreshable() 			return true end

function Primary_Nature_Attendants:OnSpellStart()
    local caster=self:GetCaster()
    caster:EmitSound("Hero_Enchantress.NaturesAttendantsCast")
    local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.5)
    caster:AddNewModifier(caster, self, "modifier_Primary_Nature_Attendants_hp", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain})

end



modifier_Primary_Nature_Attendants_hp = class({})

function modifier_Primary_Nature_Attendants_hp:IsPurgable() 			return false end
function modifier_Primary_Nature_Attendants_hp:IsPurgeException()   	return true end
function modifier_Primary_Nature_Attendants_hp:IsHidden()				return false end
function modifier_Primary_Nature_Attendants_hp:GetAttributes()				return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Primary_Nature_Attendants_hp:OnCreated()		
    local ability = self:GetAbility()
    local caster = ability:GetCaster()
    local heal_interval = ability:GetSpecialValueFor("heal_interval")
    self.heal_int = ability:GetSpecialValueFor("basic_healing") + ability:GetSpecialValueFor("intelligence_index") * caster:GetIntellect(false)
    self.rd = ability:GetSpecialValueFor("radius")
    self.n = ability:GetSpecialValueFor("number")
    if IsServer() then
        self.rd = self.rd + self:GetParent():GetCastRangeBonus() 
        self.rd = math.max(self.rd,100)
        self.particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count8.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle2, 0, self:GetParent():GetAbsOrigin())
        for num = 3, 9 do 
            ParticleManager:SetParticleControlEnt(self.particle2, num,  self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",  self:GetParent():GetAbsOrigin(), true)
        end
        ParticleManager:SetParticleControl(self.particle2, 60, Vector(RandomInt(0,255),RandomInt(0,255),RandomInt(0,255)))
        ParticleManager:SetParticleControl(self.particle2, 61, Vector(1,1,1))
        self:AddParticle(self.particle2, false, false, 100, false, false) 
    	self:StartIntervalThink(heal_interval)
    end	
end

function modifier_Primary_Nature_Attendants_hp:OnRefresh()		
   self:OnCreated()	
end

function modifier_Primary_Nature_Attendants_hp:OnIntervalThink()	
    local facing_direction = self:GetParent():GetAnglesAsVector().y


    local heros = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self.rd, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)               
    if #heros>0 then 
        local i = 1
        local num = 1
        local end_i = 0
        local healing_table = {}
        while true do
            if i > #heros then
                i = 1
            end
            if heros[i]:GetHealth() ~= heros[i]:GetMaxHealth() then
                local healing = HealWithGain(self.heal_int,self:GetParent(),heros[i],self:GetAbility())
                if healing>0 then
                    if healing_table[heros[i]] then
                        healing_table[heros[i]].healing_counut = healing_table[heros[i]].healing_counut+healing
                    else
                        healing_table[heros[i]] = {}
                        healing_table[heros[i]].healing_counut = healing
                        healing_table[heros[i]].hero = heros[i]
                    end

                end
                num = num + 1
                i = i + 1
            else
                i = i + 1
                end_i = end_i +1
            end
            if end_i > self.n or num > self.n then
                break
            end
        end

        for _, hero in ipairs(heros) do
            if healing_table[hero] then
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,hero, healing_table[hero].healing_counut, nil) 
            end
        end
    end
end	


