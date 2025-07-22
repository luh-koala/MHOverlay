function Initialize()
    -- Carrega as variáveis do arquivo .ini uma vez na inicialização
    flashTriggerTime = tonumber(SKIN:GetVariable('FlashTriggerTime'))
    maxFlashes = tonumber(SKIN:GetVariable('MaxFlashes'))
    flashInterval = tonumber(SKIN:GetVariable('FlashInterval'))
    glowDuration = tonumber(SKIN:GetVariable('GlowDuration'))

    -- Variável interna do Lua para controlar o tempo do último flash da sequência
    -- Começa em 0 para indicar que nenhum flash programado ocorreu ainda
    lastFlashTriggerTime = 0
    -- Variável para rastrear o início do último intervalo de FlashTriggerTime
    lastIntervalStart = 0
end

function Update()
    -- Obtém o estado atual do timer a cada atualização
    local timerStarted = tonumber(SKIN:GetVariable('TimerStarted'))

    -- Se o timer não estiver rodando, reseta a lógica de flash e encerra a função
    if timerStarted == 0 then
        if lastFlashTriggerTime ~= 0 or lastIntervalStart ~= 0 then
            lastFlashTriggerTime = 0
            lastIntervalStart = 0
            SKIN:Bang('!SetVariable', 'FlashCount', 0)
        end
        return
    end

    -- Obtém os valores necessários para os cálculos de tempo
    local currentTime = SKIN:GetMeasure('MeasureTime'):GetValue()
    local startTime = tonumber(SKIN:GetVariable('StartTime'))
    local flashCount = tonumber(SKIN:GetVariable('FlashCount'))

    -- Calcula o tempo decorrido em milissegundos
    -- A skin atualiza a cada 50ms (Update=50), então cada 'tick' do MeasureTime equivale a 50ms
    local elapsed_ms = (currentTime - startTime) * 50

    -- Verifica se estamos em um novo intervalo de FlashTriggerTime
    local currentInterval = math.floor(elapsed_ms / flashTriggerTime)

    -- Se o intervalo atual mudou, reinicia a contagem de flashes
    if currentInterval * flashTriggerTime > lastIntervalStart then
        flashCount = 0
        SKIN:Bang('!SetVariable', 'FlashCount', 0)
        lastFlashTriggerTime = 0
        lastIntervalStart = currentInterval * flashTriggerTime
    end

    -- CONDIÇÃO PRINCIPAL: Verifica se já passou o tempo para iniciar uma sequência de flashes
    -- e se o número máximo de flashes para o intervalo atual ainda não foi atingido
    if elapsed_ms >= currentInterval * flashTriggerTime and flashCount < maxFlashes then
        -- Calcula o tempo desde o último flash da sequência em milissegundos
        local timeSinceLastFlash_ms = (currentTime - lastFlashTriggerTime) * 50
        
        -- Define o intervalo necessário entre o início de um flash e o próximo
        local requiredInterval = glowDuration + flashInterval

        -- CONDIÇÃO DE FLASH: Verifica se é o primeiro flash da sequência (lastFlashTriggerTime == 0)
        -- ou se já passou tempo suficiente desde o último flash (duração do brilho + intervalo)
        if lastFlashTriggerTime == 0 or timeSinceLastFlash_ms >= requiredInterval then
            -- É hora de piscar!
            
            -- 1. Atualiza o contador de flashes
            flashCount = flashCount + 1
            SKIN:Bang('!SetVariable', 'FlashCount', flashCount)
            
            -- 2. Define o tempo de início do brilho para o momento atual
            SKIN:Bang('!SetVariable', 'GlowStartTime', currentTime)
            
            -- 3. Atualiza a variável de controle de tempo interna
            lastFlashTriggerTime = currentTime

            -- 4. Garante que o medidor de brilho seja exibido e redesenhado
            SKIN:Bang('!ShowMeter', 'MeterGlow')
            SKIN:Bang('!UpdateMeter', 'MeterGlow')
            SKIN:Bang('!Redraw')
        end
    end
end