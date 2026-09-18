
--------------------------------------------------------------------------------
modifier_novice_player_particle = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_novice_player_particle:IsHidden()return true end
function modifier_novice_player_particle:IsDebuff()return false end
function modifier_novice_player_particle:IsStunDebuff()return false end
function modifier_novice_player_particle:IsPurgable()return false end
function modifier_novice_player_particle:GetTexture() return "marci_unleash" end
function modifier_novice_player_particle:IsPurgeException() 	return false end
function modifier_novice_player_particle:RemoveOnDeath() return false end



function modifier_novice_player_particle:OnCreated(keys)
    if IsServer() then
        local parent = self:GetParent()

        local pos = Entities:FindByName(nil, 'teleport_point'):GetAbsOrigin()

        self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/newplayer/move_to_arrow/effect_goal.vpcf", PATTACH_WORLDORIGIN, nil,parent:GetPlayerOwner() )
        ParticleManager:SetParticleControl( self.effect_cast, 0, pos )



        self.effect_cast2 = ParticleManager:CreateParticleForPlayer( "particles/ui_mouseactions/custom_range_finder_cone.vpcf", PATTACH_CUSTOMORIGIN, parent,parent:GetPlayerOwner() )
        ParticleManager:SetParticleControlEnt( self.effect_cast2, 0, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true )
        ParticleManager:SetParticleControlEnt( self.effect_cast2, 1, parent, PATTACH_POINT_FOLLOW, "", parent:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( self.effect_cast2, 2, pos)
        ParticleManager:SetParticleControl( self.effect_cast2, 3, Vector(100,100,0))
        ParticleManager:SetParticleControl( self.effect_cast2, 4, Vector(96,255,43))
        ParticleManager:SetParticleControl( self.effect_cast2, 6, Vector(1,1,1))




    end
    
    

end


function modifier_novice_player_particle:OnDestroy()
    if IsServer() then
        if self.effect_cast then
            ParticleManager:DestroyParticle(self.effect_cast,true)
        end
        if self.effect_cast2 then
            ParticleManager:DestroyParticle(self.effect_cast2,true)
        end
    end
end


function modifier_novice_player_particle:ADDeclareFunctions()
    return 
    {

		MODIFIER_EVENT_ON_Wave_Start = {},
    }
end




function modifier_novice_player_particle:OnWaveStart()
    if IsServer() then
		self:Destroy()
	end
end
