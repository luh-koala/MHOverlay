function Initialize()
    -- Carrega as variáveis do arquivo .ini com valores padrão caso falhem
    flashInterval = tonumber(SKIN:GetVariable('FlashInterval')) or 100
    maxFlashes = tonumber(SKIN:GetVariable('MaxFlashes')) or 2
    glowDuration = tonumber(SKIN:GetVariable('GlowDuration')) or 1000
    cooldownDuration = tonumber(SKIN:GetVariable('CooldownDuration')) or 30000
    
    -- Variáveis internas
    -- lastFlashTime será usado para controlar o intervalo entre os flashes dentro de um ciclo
    lastFlashTime = 0
end

function Update()
    local currentTime = SKIN:GetMeasure('MeasureTime'):GetValue()
    local isCooldown = tonumber(SKIN:GetVariable('IsCooldown'))
    local flashCount = tonumber(SKIN:GetVariable('FlashCount'))
    local isVisible = tonumber(SKIN:GetVariable('IsVisible'))
    local flashStartTime = tonumber(SKIN:GetVariable('FlashStartTime')) -- Pegar o FlashStartTime do INI
    
    if isCooldown == 1 then
        -- Durante o cooldown, a skin permanece escondida
        if isVisible == 1 then
            SKIN:Bang('!HideMeter', 'MeterSkillHigh')
            SKIN:Bang('!HideMeter', 'MeterGlow') -- Garantir que o glow também esteja escondido
            SKIN:Bang('!SetVariable', 'IsVisible', 0)
            SKIN:Bang('!Redraw')
        end
        return
    end
    
    -- Após o cooldown, verificar se é hora de piscar
    if flashCount < maxFlashes then
        -- Calcula o tempo desde o último flash, em unidades de MeasureTime (50ms por tick)
        -- lastFlashTime é 0 no início ou após um flash.
        -- currentTime é o valor atual de MeasureTime.
        local timeSinceLastIndividualFlash = currentTime - lastFlashTime
        
        -- O intervalo necessário é a duração do brilho mais o intervalo entre flashes
        -- Ambos em milissegundos, convertidos para ticks de MeasureTime (dividindo por 50)
        local requiredIntervalTicks = (glowDuration + flashInterval) / 50
        
        if lastFlashTime == 0 or timeSinceLastIndividualFlash >= requiredIntervalTicks then
            -- Inicia um novo flash
            SKIN:Bang('!SetVariable', 'FlashStartTime', currentTime) -- Define o início do brilho
            SKIN:Bang('!ShowMeter', 'MeterGlow')
            SKIN:Bang('!HideMeter', 'MeterSkillHigh') -- Garantir que a imagem da skill esteja escondida durante o glow
            SKIN:Bang('!UpdateMeter', 'MeterGlow')
            SKIN:Bang('!Redraw')
            
            lastFlashTime = currentTime -- Atualiza o tempo do último flash
            flashCount = flashCount + 1
            SKIN:Bang('!SetVariable', 'FlashCount', flashCount)
        end
    else
        -- Após os flashes, mostrar a imagem SkillHigh e esconder o glow
        if isVisible == 0 then
            SKIN:Bang('!ShowMeter', 'MeterSkillHigh')
            SKIN:Bang('!HideMeter', 'MeterGlow')
            SKIN:Bang('!SetVariable', 'IsVisible', 1)
            SKIN:Bang('!Redraw')
            -- Reset lastFlashTime para o próximo ciclo, caso o ToggleVisibility não seja chamado
            lastFlashTime = 0 
        end
    end
end

function ToggleVisibility()
    local isVisible = tonumber(SKIN:GetVariable('IsVisible'))
    local currentTime = SKIN:GetMeasure('MeasureTime'):GetValue()
    
    -- Só esconde a skill e inicia o cooldown SE ela estiver visível
    if isVisible == 1 then
        SKIN:Bang('!HideMeter', 'MeterSkillHigh')
        SKIN:Bang('!HideMeter', 'MeterGlow')
        SKIN:Bang('!SetVariable', 'IsVisible', 0)
        SKIN:Bang('!SetVariable', 'IsCooldown', 1)
        SKIN:Bang('!SetVariable', 'StartTime', currentTime)
        SKIN:Bang('!SetVariable', 'FlashCount', 0)
        SKIN:Bang('!SetVariable', 'FlashStartTime', 0) -- Resetar FlashStartTime para o próximo ciclo de flashes
        lastFlashTime = 0 -- Resetar lastFlashTime no Lua também
        SKIN:Bang('!UpdateMeasure', 'MeasureCooldown')
        SKIN:Bang('!Redraw')
    end
    -- Se isVisible não for 1 (ou seja, se a skill estiver escondida ou em cooldown),
    -- pressionar 'W' não terá efeito.
end