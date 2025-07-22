local executed = false

function Initialize()
  if not executed then
    executed = true
    
    -- Este comando simplesmente ativa a medida [MeasureRunAHK] no arquivo .ini
    SKIN:Bang('!CommandMeasure', 'MeasureRunAHK', 'Run')
    
    -- Para depuração, vamos logar a ação
    SKIN:Bang('!Log', 'Comando para executar [MeasureRunAHK] foi enviado.')
  end
end