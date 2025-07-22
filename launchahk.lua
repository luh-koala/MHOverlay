local executed = false

function Initialize()
  if not executed then
    executed = true
    os.execute('start "" "C:\\Users\\User\\Documents\\Rainmeter\\Skins\\SkillTimer\\AtalhoBuff6.ahk"')
  end
end