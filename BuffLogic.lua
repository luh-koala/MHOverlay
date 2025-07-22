function Initialize()
end

function Activate(n)
    local SK = SKIN
    local now = tonumber(SK:GetMeasure("MeasureNow"):GetValue())

    if n == 5 then
        local buffEnd = tonumber(SK:GetVariable("Buff5End"))
        local cooldownEnd = tonumber(SK:GetVariable("Cooldown5End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + 22
            local newCooldownEnd = now + 30
            SK:Bang('!SetVariable', "Buff5End", newBuffEnd)
            SK:Bang('!SetVariable', "Cooldown5End", newCooldownEnd)
            SK:Bang('!UpdateMeasure', "MeasureBuff5Diff")
            SK:Bang('!ShowMeter', "MeterIcon5")
            SK:Bang('!ShowMeter', "MeterText5")
            SK:Bang('!UpdateMeter', '*')
            SK:Bang('!Redraw')
        end
    elseif n == 7 then
        local buffEnd = tonumber(SK:GetVariable("Buff7End"))
        local cooldownEnd = tonumber(SK:GetVariable("Cooldown7End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + 10
            local newCooldownEnd = now + 60
            SK:Bang('!SetVariable', "Buff7End", newBuffEnd)
            SK:Bang('!SetVariable', "Cooldown7End", newCooldownEnd)
            SK:Bang('!UpdateMeasure', "MeasureBuff7Diff")
            SK:Bang('!ShowMeter', "MeterIcon7")
            SK:Bang('!ShowMeter', "MeterText7")
            SK:Bang('!UpdateMeter', '*')
            SK:Bang('!Redraw')
        end
    elseif n == 8 then
        local buffEnd = tonumber(SK:GetVariable("Buff8End"))
        local cooldownEnd = tonumber(SK:GetVariable("Cooldown8End"))
        if now >= cooldownEnd and now >= buffEnd then
            local newBuffEnd = now + 26
            local newCooldownEnd = now + 60
            SK:Bang('!SetVariable', "Buff8End", newBuffEnd)
            SK:Bang('!SetVariable', "Cooldown8End", newCooldownEnd)
            SK:Bang('!UpdateMeasure', "MeasureBuff8Diff")
            SK:Bang('!ShowMeter', "MeterIcon8")
            SK:Bang('!ShowMeter', "MeterText8")
            SK:Bang('!UpdateMeter', '*')
            SK:Bang('!Redraw')
        end
    elseif n == 9 then
        -- Não ative por aqui, use ActivateDelayed!
        return
    else
        local timerVar = "Timer"..n.."End"
        local setTimerMeasure = "MeasureSetTimer"..n
        local newEnd = tonumber(SK:GetMeasure(setTimerMeasure):GetValue())
        SK:Bang('!SetVariable', timerVar, newEnd)
        SK:Bang('!UpdateMeasure', "MeasureTimer"..n)
        SK:Bang('!UpdateMeasure', "MeasureDiff"..n)
        SK:Bang('!ShowMeter', "MeterIcon"..n)
        SK:Bang('!ShowMeter', "MeterText"..n)
        SK:Bang('!UpdateMeter', '*')
        SK:Bang('!Redraw')
    end
end

function ActivateDelayed(n, delay)
    local SK = SKIN
    local now = tonumber(SK:GetMeasure("MeasureNow"):GetValue())
    local timerVar = "Timer"..n.."End"
    local duration = tonumber(SK:GetVariable("TimerDuration"..n))
    SK:Bang('!SetVariable', "Skill9DelayStart", now + delay)
    local newEnd = now + delay + duration
    SK:Bang('!SetVariable', timerVar, newEnd)
    SK:Bang('!UpdateMeasure', "MeasureTimer"..n)
    SK:Bang('!UpdateMeasure', "MeasureDiff"..n)
    SK:Bang('!HideMeter', "MeterIcon"..n)
    SK:Bang('!HideMeter', "MeterText"..n)
    SK:Bang('!UpdateMeter', '*')
    SK:Bang('!Redraw')
end