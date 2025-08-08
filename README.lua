-- GUI MULTIFUNCIONAL: Aimbot, ESP, Super Pulo, Velocidade, Teleporte e mais
-- Funciona em PC e Celular, GUI movível, minimizável

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Criar GUI responsiva
local function criarGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MultiFuncGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    local screenSize = Camera.ViewportSize

    -- Frame principal
    local mainSize, mainPos
    if isMobile then
        mainSize = UDim2.new(0.9, 0, 0.8, 0)
        mainPos = UDim2.new(0.05, 0, 0.1, 0)
    else
        mainSize = UDim2.new(0, 420, 0, 480)
        mainPos = UDim2.new(0.5, -210, 0.08, 0)
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = mainSize
    mainFrame.Position = mainPos
    mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true -- necessário para drag no celular
    mainFrame.Parent = screenGui
    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Parent = mainFrame
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "Painel Multifuncional"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Botão minimizar
    local btnMin = Instance.new("TextButton")
    btnMin.Text = "-"
    btnMin.Font = Enum.Font.GothamBold
    btnMin.TextSize = 24
    btnMin.TextColor3 = Color3.new(1, 1, 1)
    btnMin.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    btnMin.Size = UDim2.new(0, 40, 0, 30)
    btnMin.Position = UDim2.new(1, -90, 0, 5)
    btnMin.Parent = titleBar
    btnMin.AutoButtonColor = true
    btnMin.Name = "MinimizeButton"
    btnMin.ZIndex = 2
    local minCorner = Instance.new("UICorner", btnMin)
    minCorner.CornerRadius = UDim.new(0, 6)

    -- Botão fechar
    local btnClose = Instance.new("TextButton")
    btnClose.Text = "X"
    btnClose.Font = Enum.Font.GothamBold
    btnClose.TextSize = 20
    btnClose.TextColor3 = Color3.new(1, 1, 1)
    btnClose.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    btnClose.Size = UDim2.new(0, 40, 0, 30)
    btnClose.Position = UDim2.new(1, -45, 0, 5)
    btnClose.Parent = titleBar
    btnClose.AutoButtonColor = true
    btnClose.Name = "CloseButton"
    btnClose.ZIndex = 2
    local closeCorner = Instance.new("UICorner", btnClose)
    closeCorner.CornerRadius = UDim.new(0, 6)

    -- Área do conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -12, 1, -50)
    contentFrame.Position = UDim2.new(0, 6, 0, 44)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Abas
    local tabNames = {"Jogadores", "Aimbot", "Extras"}
    local tabButtons = {}
    local tabPages = {}

    local tabButtonWidth = (isMobile and (screenSize.X * 0.9 / #tabNames) - 10) or 120

    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.Parent = contentFrame

    for i, name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, tabButtonWidth, 0, 34)
        btn.Position = UDim2.new(0, (i-1)*(tabButtonWidth+10), 0, 3)
        btn.Text = name
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
        btn.TextColor3 = Color3.new(1,1,1)
        local uic = Instance.new("UICorner", btn)
        uic.CornerRadius = UDim.new(0, 6)
        btn.Parent = tabsFrame
        tabButtons[i] = btn

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, -6, 1, -50)
        page.Position = UDim2.new(0, 3, 0, 44)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = contentFrame
        tabPages[i] = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(tabPages) do
                p.Visible = false
            end
            page.Visible = true
        end)
    end

    tabPages[1].Visible = true -- Aba "Jogadores" ativa ao iniciar

    -- Função para permitir arrastar o frame principal
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        mainFrame.Position = newPos
    end

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Botão minimizar
    local minimized = false
    btnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            contentFrame.Visible = false
            mainFrame.Size = UDim2.new(mainFrame.Size.X.Scale, mainFrame.Size.X.Offset, 0, 40)
        else
            contentFrame.Visible = true
            mainFrame.Size = mainSize
        end
    end)

    -- Botão fechar
    btnClose.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- -----------------------------------
    -- Aba Jogadores (ESP e Teleporte)
    -- -----------------------------------

    local playersList = Instance.new("ScrollingFrame")
    playersList.Size = UDim2.new(1, -12, 1, -12)
    playersList.Position = UDim2.new(0, 6, 0, 6)
    playersList.BackgroundTransparency = 1
    playersList.CanvasSize = UDim2.new(0, 0, 0, 0)
    playersList.ScrollBarThickness = 6
    playersList.Parent = tabPages[1]

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.Parent = playersList

    -- Função para criar botão de jogador na lista
    local function criarBotaoJogador(jogador)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.Text = jogador.Name
        btn.AutoButtonColor = true
        local corner = Instance.new("UICorner", btn)
        corner.CornerRadius = UDim.new(0, 6)

        -- Teleportar para jogador ao clicar
        btn.MouseButton1Click:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                jogador.Character and jogador.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = jogador.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            end
        end)

        btn.Parent = playersList
        return btn
    end

    -- Atualiza lista de jogadores na aba
    local function atualizarListaJogadores()
        playersList:ClearAllChildren()
        for _, jogador in pairs(Players:GetPlayers()) do
            if jogador ~= LocalPlayer then
                criarBotaoJogador(jogador)
            end
        end
        -- Atualiza o CanvasSize para scroll
        wait() -- pequeno delay para UIListLayout atualizar
        local totalSize = UIListLayout.AbsoluteContentSize.Y
        playersList.CanvasSize = UDim2.new(0, 0, 0, totalSize + 10)
    end
    atualizarListaJogadores()

    Players.PlayerAdded:Connect(atualizarListaJogadores)
    Players.PlayerRemoving:Connect(atualizarListaJogadores)

    -- -----------------------------------
    -- Aba Aimbot
    -- -----------------------------------

    local aimbotEnabled = false
    local aimlockEnabled = false
    local aimTarget = nil
    local aimPartName = "Head" -- Parte para mirar

    local aimbotPage = tabPages[2]

    local toggleAimbot = Instance.new("TextButton")
    toggleAimbot.Size = UDim2.new(0, 150, 0, 40)
    toggleAimbot.Position = UDim2.new(0, 20, 0, 20)
    toggleAimbot.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
    toggleAimbot.TextColor3 = Color3.new(1,1,1)
    toggleAimbot.Font = Enum.Font.GothamBold
    toggleAimbot.TextSize = 16
    toggleAimbot.Text = "Ativar Aimbot"
    toggleAimbot.Parent = aimbotPage
    local toggleCorner = Instance.new("UICorner", toggleAimbot)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -40, 0, 30)
    infoLabel.Position = UDim2.new(0, 20, 0, 70)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.new(1,1,1)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 14
    infoLabel.Text = "Aimbot mira somente jogadores vivos e visíveis"
    infoLabel.Parent = aimbotPage

    -- Função que verifica se o personagem está visível (sem parede na frente)
    local function estaVisivel(originPos, targetPart)
        local ray = Ray.new(originPos, (targetPart.Position - originPos).Unit * 500)
        local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")})
        if hit then
            -- Se o hit for parte do personagem alvo, está visível
            if targetPart:IsDescendantOf(hit.Parent) then
                return true
            else
                return false
            end
        else
            return true
        end
    end

    -- Função para encontrar o jogador mais próximo do cursor (mouse ou centro da tela no celular)
    local function findClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge

        local originPos = Camera.CFrame.Position
        local mousePos = nil

        if not isMobile then
            local mouse = LocalPlayer:GetMouse()
            mousePos = Vector2.new(mouse.X, mouse.Y)
        else
            -- Centro da tela para mobile
            mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(aimPartName) and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.Health > 0 then
                    local part = player.Character[aimPartName]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortestDistance and estaVisivel(originPos, part) then
                            shortestDistance = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end

        return closestPlayer
    end

    -- Toggle aimbot
    toggleAimbot.MouseButton1Click:Connect(function()
        aimbotEnabled = not aimbotEnabled
        if aimbotEnabled then
            toggleAimbot.Text = "Desativar Aimbot"
            toggleAimbot.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        else
            toggleAimbot.Text = "Ativar Aimbot"
            toggleAimbot.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
        end
    end)

    -- Loop para controlar a mira
    RunService.RenderStepped:Connect(function()
        if aimbotEnabled then
            local targetPlayer = findClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(aimPartName) then
                local targetPart = targetPlayer.Character[aimPartName]
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
        end
    end)

    -- -----------------------------------
    -- Aba Extras (ESP, Speed, Jump, Desconectar)
    -- -----------------------------------

    local extrasPage = tabPages[3]

    -- Toggle ESP
    local espEnabled = false
    local espBoxes = {}

    local toggleESPBtn = Instance.new("TextButton")
    toggleESPBtn.Size = UDim2.new(0, 150, 0, 40)
    toggleESPBtn.Position = UDim2.new(0, 20, 0, 20)
    toggleESPBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
    toggleESPBtn.TextColor3 = Color3.new(1,1,1)
    toggleESPBtn.Font = Enum.Font.GothamBold
    toggleESPBtn.TextSize = 16
    toggleESPBtn.Text = "Ativar ESP"
    toggleESPBtn.Parent = extrasPage
    local espCorner = Instance.new("UICorner", toggleESPBtn)
    espCorner.CornerRadius = UDim.new(0, 8)

    toggleESPBtn.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            toggleESPBtn.Text = "Desativar ESP"
            toggleESPBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            -- Criar ESP para cada jogador
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if not espBoxes[player] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = nil
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Color3 = Color3.new(0, 1, 0)
                        box.Size = Vector3.new(4, 6, 1)
                        box.Transparency = 0.5
                        box.Parent = workspace.CurrentCamera
                        espBoxes[player] = box
                    end
                end
            end
        else
            toggleESPBtn.Text = "Ativar ESP"
            toggleESPBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
            -- Remover todos ESP
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
    end)

    -- Atualiza as posições do ESP sempre
    RunService.RenderStepped:Connect(function()
        if espEnabled then
            for player, box in pairs(espBoxes) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local humanoid = player.Character.Humanoid
                    if humanoid.Health > 0 then
                        local rootPart = player.Character.HumanoidRootPart
                        box.Adornee = rootPart
                        -- Ajusta tamanho da caixa conforme altura do personagem
                        box.Size = Vector3.new(4, humanoid.HipHeight * 2 + 3, 1)
                        box.Color3 = Color3.new(0, 1, 0)
                        box.Transparency = 0.4
                        box.AlwaysOnTop = true
                    else
                        box.Adornee = nil
                    end
                else
                    box.Adornee = nil
                end
            end
        end
    end)

    -- Slider para Speed (Velocidade)
    local speedValue = 16
    local speedSliderLabel = Instance.new("TextLabel")
    speedSliderLabel.Size = UDim2.new(0, 180, 0, 20)
    speedSliderLabel.Position = UDim2.new(0, 20, 0, 80)
    speedSliderLabel.BackgroundTransparency = 1
    speedSliderLabel.TextColor3 = Color3.new(1,1,1)
    speedSliderLabel.Font = Enum.Font.Gotham
    speedSliderLabel.TextSize = 14
    speedSliderLabel.Text = "Velocidade: "..speedValue
    speedSliderLabel.Parent = extrasPage

    local speedSlider = Instance.new("TextBox")
    speedSlider.Size = UDim2.new(0, 80, 0, 20)
    speedSlider.Position = UDim2.new(0, 210, 0, 80)
    speedSlider.Text = tostring(speedValue)
    speedSlider.ClearTextOnFocus = false
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.TextSize = 14
    speedSlider.TextColor3 = Color3.new(1,1,1)
    speedSlider.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local speedSliderCorner = Instance.new("UICorner", speedSlider)
    speedSliderCorner.CornerRadius = UDim.new(0, 6)
    speedSlider.Parent = extrasPage

    speedSlider.FocusLost:Connect(function(enterPressed)
        local num = tonumber(speedSlider.Text)
        if num and num >= 8 and num <= 150 then
            speedValue = num
            speedSliderLabel.Text = "Velocidade: "..speedValue
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speedValue
            end
        else
            speedSlider.Text = tostring(speedValue)
        end
    end)

    -- Toggle Super Pulo
    local jumpEnabled = false
    local jumpPowerValue = 50
    local toggleJumpBtn = Instance.new("TextButton")
    toggleJumpBtn.Size = UDim2.new(0, 150, 0, 40)
    toggleJumpBtn.Position = UDim2.new(0, 20, 0, 120)
    toggleJumpBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
    toggleJumpBtn.TextColor3 = Color3.new(1,1,1)
    toggleJumpBtn.Font = Enum.Font.GothamBold
    toggleJumpBtn.TextSize = 16
    toggleJumpBtn.Text = "Ativar Super Pulo"
    toggleJumpBtn.Parent = extrasPage
    local jumpCorner = Instance.new("UICorner", toggleJumpBtn)
    jumpCorner.CornerRadius = UDim.new(0, 8)

    toggleJumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            toggleJumpBtn.Text = "Desativar Super Pulo"
            toggleJumpBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = jumpPowerValue
            end
        else
            toggleJumpBtn.Text = "Ativar Super Pulo"
            toggleJumpBtn.BackgroundColor3 = Color3.fromRGB(80, 170, 80)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50 -- padrão Roblox
            end
        end
    end)

    -- Botão para desconectar (fechar o script)
    local btnDisconnect = Instance.new("TextButton")
    btnDisconnect.Size = UDim2.new(0, 150, 0, 40)
    btnDisconnect.Position = UDim2.new(0, 20, 0, 170)
    btnDisconnect.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    btnDisconnect.TextColor3 = Color3.new(1,1,1)
    btnDisconnect.Font = Enum.Font.GothamBold
    btnDisconnect.TextSize = 16
    btnDisconnect.Text = "Desconectar Script"
    btnDisconnect.Parent = extrasPage
    local disconCorner = Instance.new("UICorner", btnDisconnect)
    disconCorner.CornerRadius = UDim.new(0, 8)

    btnDisconnect.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        -- Limpa ESP
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
        aimbotEnabled = false
    end)

    -- Retorna referências para poder expandir futuramente
    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        aimbotEnabled = function() return aimbotEnabled end,
        espEnabled = function() return espEnabled end,
    }
end

-- Criar a GUI
local gui = criarGUI()

print("GUI Multifuncional carregada! Use as abas para navegar pelas funções.")

