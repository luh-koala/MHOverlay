function Activate(id)
    local now = tonumber(SKIN:GetMeasure("MeasureNow"):GetValue())

    if id == 'W1' then
        local buffEnd = tonumber(SKIN:GetVariable("BuffW1End"))
        local cooldownEnd = tonumber(SKIN:GetVariable("CooldownW1End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + tonumber(SKIN:GetVariable("BuffDurationW1"))
            local newCooldownEnd = now + tonumber(SKIN:GetVariable("CooldownDurationW1"))
            SKIN:Bang('!SetVariable', "BuffW1End", newBuffEnd)
            SKIN:Bang('!SetVariable', "CooldownW1End", newCooldownEnd)
            SKIN:Bang('!UpdateMeasure', "MeasureBuffW1Diff")
        end
    elseif id == 'W2' then
        local buffEnd = tonumber(SKIN:GetVariable("BuffW2End"))
        local cooldownEnd = tonumber(SKIN:GetVariable("CooldownW2End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + tonumber(SKIN:GetVariable("BuffDurationW2"))
            local newCooldownEnd = now + tonumber(SKIN:GetVariable("CooldownDurationW2"))
            SKIN:Bang('!SetVariable', "BuffW2End", newBuffEnd)
            SKIN:Bang('!SetVariable', "CooldownW2End", newCooldownEnd)
            SKIN:Bang('!UpdateMeasure', "MeasureBuffW2Diff")
        end
    elseif id == 'W3' then
        local buffEnd = tonumber(SKIN:GetVariable("BuffW3End"))
        local cooldownEnd = tonumber(SKIN:GetVariable("CooldownW3End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + tonumber(SKIN:GetVariable("BuffDurationW3"))
            local newCooldownEnd = now + tonumber(SKIN:GetVariable("CooldownDurationW3"))
            SKIN:Bang('!SetVariable', "BuffW3End", newBuffEnd)
            SKIN:Bang('!SetVariable', "CooldownW3End", newCooldownEnd)
            SKIN:Bang('!UpdateMeasure', "MeasureBuffW3Diff")
        end
    else
        local timerVar = "Timer" .. id .. "End"
        local setTimerMeasure = "MeasureSetTimer" .. id
        local diffMeasure = "MeasureDiff" .. id
        
        local newEnd = tonumber(SKIN:GetMeasure(setTimerMeasure):GetValue())
        SKIN:Bang('!SetVariable', timerVar, newEnd)
        SKIN:Bang('!UpdateMeasure', diffMeasure)
    end
    
    SKIN:Bang('!UpdateMeter', '*')
    SKIN:Bang('!Redraw')
end

function ActivateGroupW()
    -- Ativa os 3 primeiros buffs normalmente
    Activate('W1')
    Activate('W2')
    Activate('W3')

    -- Lê o valor do delay do arquivo .ini. Se não encontrar, usa 4 como padrão.
    local delayW4 = tonumber(SKIN:GetVariable('DelayDurationW4', 4))
    
    -- Ativa o 4º buff com o delay que foi lido do .ini
    ActivateDelayed('W4', delayW4)
end

function ActivateDelayed(id, delay)
    local now = tonumber(SKIN:GetMeasure("MeasureNow"):GetValue())
    
    local timerVar = "Timer" .. id .. "End"
    local delayStartVar = "Skill" .. id .. "DelayStart"
    local duration = tonumber(SKIN:GetVariable("TimerDuration" .. id))
    local diffMeasure = "MeasureDiff" .. id

    SKIN:Bang('!SetVariable', delayStartVar, now + delay)
    local newEnd = now + delay + duration
    SKIN:Bang('!SetVariable', timerVar, newEnd)
    SKIN:Bang('!UpdateMeasure', diffMeasure)
end