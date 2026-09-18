chaotic_summon_null = class({})
--GetGloabal_ChaoticEra__ShopLevel(unit) 获取商店

function chaotic_summon_null:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_beastmaster/beastmaster_call_boar.vpcf", context )
end

function chaotic_summon_null:IsSummonSpell()return true end
function chaotic_summon_null:OnSpellStart()
	local count = self:GetSpecialValueFor("max_count")
	if not self.summon_table then
		self.summon_table = {}
	end
	UpdateSummonMaxCount(self.summon_table,count)
	local caster =self:GetCaster()
    local health = 0
    local attack = 0
    local armor = self:GetSpecialValueFor("bonus_armor")*0.01 * caster:GetPhysicalArmorValue(false)

    local shop = chaotic_era_shop:GetPlayerShopLevel(caster:GetPlayerOwnerID(),true)
    -- print("商店等级是"..shop)
    if shop <= 3 then
        attack = 70 + 5*shop
        health = 56 + 5*shop
        -- print("1-3级商店.."..attack)
    elseif shop > 3 and shop <= 7 then
        attack = 80 + 4*shop
        health = 70 + 4*shop
        -- print("4-7级商店.."..attack)
    elseif shop > 7 then
        attack = 100 + 3*shop
        health = 91 + 3*shop
        -- print("8-13级商店.."..attack)
    end
        
        
	local life_duration = self:GetSpecialValueFor("duration") 
	local heal = health*0.01 * caster:GetMaxHealth()*1.2
	local damage = attack*0.01 * math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetBaseDamageMax()*7) + 100
	
	local unit_pos = self:GetCaster():GetAbsOrigin() + (self:GetCaster():GetForwardVector() * 200) 
	local unit = caster:SummonUnit("npc_hd_null",life_duration,
	unit_pos,
	caster:GetForwardVector(),self,0,heal,nil,damage,armor,1,1)

	table.insert(self.summon_table,unit)
	unit:AddNewModifier(caster, self, "modifier_chaotic_summon_null_buff", {})
end
