--==============================================================
-- H4XDARLING009 Hub v3.0 (ĐÃ SỬA - GIỮ NGUYÊN MENU WINDUI)
-- 1. Menu giữ nguyên y hệt bản gốc (WindUI, sidebar)
-- 2. Bấm tên script -> cửa sổ HIỆN LUÔN CODE bên trong script đó
--    (có nút ▶ Chạy và 📋 Copy)
-- 3. Cửa sổ xem code tự tạo chạy TRƯỚC -> dù menu WindUI lỗi vẫn có
--    thông báo lỗi cụ thể trên màn hình
-- 4. TRANG CHỦ có nút Discord / TikTok — bấm là copy link
--    (Roblox ko tự mở trang web được -> copy rồi dán vào trình duyệt)
-- 5. TRANG CHỦ có BẢNG GIÁ CÀY THUÊ bằng chữ (nút 📋 Copy)
-- 6. Ấn nút — trên menu -> menu thu nhỏ thành thanh nhỏ trên cùng,
--    bấm thanh đó mở lại menu (ĐÃ BỎ nút tròn hồng).
--    PC = thanh pill mình tự vẽ, giờ bo giống hệt pill gốc trên mobi
--    (nền đen đậm, viền gradient xanh->tím, ô icon ✥ màu hồng bên trái + vạch chia).
--    MOBI = WindUI tự sinh thanh của nó rồi -> hub KHÔNG vẽ pill nữa,
--    hết bị 2 thanh trùng nhau. Đổi tay: CUSTOM_PILL_MODE ở dưới.
-- 7. TAB "Tăng fps" — đứng THỨ 2 trên sidebar (ngay sau Trang chủ):
--    Section "Optimization & Boost" + nut "Boost FPS (Remove Textures)":
--    QualityLevel = Level01, moi part -> Material Plastic + Reflectance 0,
--    moi Decal/Texture -> Transparency 1 (an hoa van/logo/hinh in quan ao).
--    Co the TU XU LY part sinh sau (doi dao/zone map moi) - xem
--    TU_XU_LY_PART_MOI o khoi "Tăng fps".
--    + 📊 dong ho FPS do that + nut ↩ Trả lại cài đặt gốc.
--    MOI THUOC TINH DOI DI DUOC LUU LAI -> bam [↩] hoac [R] la ve dung nhu cu,
--    khong Destroy object nao (ko mat Sky/bau troi, chi an hinh in tren quan ao).
--    Ko đụng tới speed / jump / camera / ESP / bất cứ thứ gì ảnh hưởng
--    người chơi khác -> chạy game nào cũng được, ko bị report.
-- 8. PHIM TAT: bam Left Ctrl = mo menu, bam lan nua = thu menu thanh pill
--    (bam vao thanh pill do cung mo lai duoc). Bam la mo/thu LIEN TUC,
--    khong phai cho tha tay. Neu luc giu Ctrl ma bam them phim/chuot khac
--    (Ctrl+C, Ctrl+V, Ctrl+X...) thi no tu hoan lai, nen ko pha copy/paste.
--    Doi phim: sua bang MENU_TOGGLE_KEYS ben duoi.
-- 9. DA SUA HAN LOI "tat hub roi bam Ctrl -> Roblox bi dong/ung":
--    Nguyen nhan: ta TU Destroy ScreenGui cua WindUI ma khong cho WindUI cat
--    cac ket noi noi bo cua no (keo cua, phim, tween) -> WindUI van chay tiep
--    tren do da chet, bam Ctrl la noi chien day chuyen lam vung ca game.
--    Cach nay: an X / chuot phai pill -> goi ham DON GOC cua WindUI truoc de
--    tu no don minh, xong hub moi don pill + cua so code cua no.
--    Nut — va thanh pill van goi Close/Open GOC cua WindUI (menu thu dung
--    hieu ung, khong con ki an nham cai ScreenGui khong phai cua so nhu ban
--    truoc), nhung chi duoc goi khi hubAlive = true VA con ScreenGui "WindUI"
--    song -> GUI chet thi phim tat bi cat ket noi ngay.
--    Them 3 lop bao ve nua:
--      • moi lan bam deu nam trong pcall; loi 2 lan = tu cat han phim tat
--        (menu van mo/thu duoc bang thanh pill, game khong chet nua).
--      • vong do sat 0.5s: moi ScreenGui "WindUI" deu mat = hub tu tat.
--      • don GUI khi tat hub lam theo tung buoc cach nhau 1 frame.
--    Tat hub (X / chuot phai vao pill) thi BOOST FPS + dong ho FPS VAN CON chay,
--    dieu khien bang 2 nut [x] [R] canh dong ho (xem KEEP_PERF_ON_CLOSE o duoi).
--    Ctrl sau khi tat hub chi con la phim trang, khong the lam dong Roblox.
-- 10. TAB KHONG CON BI GIOI HAN: them bao nhieu section cung hien het.
--    Sidebar cua WindUI von la ScrollingFrame nhung AN thanh cuon -> tab thu 10
--    tro di tu dong bi day xuong duoi, nhin tuong la mat. Hub giu do tong chieu
--    cao danh sach tab va PHONG TO cua so vua du hien het (toi da ~86% man hinh);
--    qua nhieu tab thi tu bat thanh cuon mau hong de keo xuong.
--    Them 20-30 tab muon tim nhanh thi doi HIEN_O_TIM_KIEM duoi day = true.
--==============================================================

-- ==================== PHIM TAT MO/TAT MENU (sua o day) ====================
-- Mac dinh: Left Ctrl (bam 1 cai la mo/thu menu ngay, ko phai giu roi tha).
-- An toan voi Ctrl+C / Ctrl+V / Ctrl+X: neu luc giu Ctrl ma co bam them
-- phim hoac chuot khac thi no tu hoan lai dung trang thai cu.
-- Them bo phat khac vao danh sach neu thich, vi du:
--   Enum.KeyCode.RightControl, Enum.KeyCode.RightShift, Enum.KeyCode.Insert, Enum.KeyCode.FFive
local MENU_TOGGLE_KEYS = {
    Enum.KeyCode.LeftControl,
}

-- ==================== TAT HUB THI BOOST FPS / FPS CO CHAY TIEP? ====================
-- true  = an X tat hub thi menu bien mat het, NHUNG do hoa da boost van con
--         nguyen + dong ho FPS van con hien goc phai duoi man hinh.
--         (Ngay canh dong ho FPS co 2 nut nho: [x] = tat dong ho (van giu boost),
--          [R] = Restore, tra lai cai dat goc cua game -> ko can mo hub nua.)
-- false = tat hub la sach will (tra lai do hoa + an FPS) nhu cu.
local KEEP_PERF_ON_CLOSE = true

-- ==================== NHIEU TAB THI CO O TIM KIEM? ====================
-- Sidebar tab KHONG bi gioi han nua (hub tu phong to cua so + bat thanh cuon).
-- De true = hien them o TIM KIEM o dau sidebar -> up 20-30 tab van tim script nhanh.
-- De false = giao dien giong het nhu cu (khong co o tim).
local HIEN_O_TIM_KIEM = false

-- ==================== XÓA MENU CŨ (chống đúp khi chạy lại) ====================
do
    local roots = {}
    pcall(function()
        if gethui then
            table.insert(roots, gethui())
        end
    end)
    pcall(function()
        table.insert(roots, game:GetService("CoreGui"))
    end)
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if pg then
            table.insert(roots, pg)
        end
    end)
    for _, root in ipairs(roots) do
        pcall(function()
            local old = root:FindFirstChild("H4XDARLING009_CodeViewer", true)
            if old then
                old:Destroy()
            end
        end)
        pcall(function()
            local oldPill = root:FindFirstChild("H4XDARLING009_Pill", true)
            if oldPill then
                oldPill:Destroy()
            end
        end)
        pcall(function()
            local oldHud = root:FindFirstChild("H4XDARLING009_PerfHud", true)
            if oldHud then
                oldHud:Destroy()
            end
        end)
        pcall(function()
            for _, sg in ipairs(root:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Name == "WindUI" then
                    sg:Destroy()
                end
            end
        end)
    end
end

-- ==================== HÀM BÁO THÔNG BÁO TRÊN MÀN HÌNH ====================
local function notify(title, text, dur)
    task.spawn(function()
        local okNotify = false
        for _ = 1, 6 do
            okNotify = pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = title,
                    Text = text,
                    Duration = dur or 5
                })
            end)
            if okNotify then
                break
            end
            task.wait(1)
        end
        if not okNotify then
            warn("[H4X Hub] " .. tostring(title) .. " | " .. tostring(text))
        end
    end)
end

-- ==================== KIEM TRA EXECUTOR CO CHAY DUOC HUB KHONG ====================
-- Nhieu executor loc loadstring/load/gethui -> hub im lang khong len duoc.
if type(loadstring) ~= "function" and type(load) ~= "function" then
    notify("Hub Lỗi", "Executor này chặn loadstring -> ko chạy hub được. Đổi executor khác (hoặc bật chế độ Luau exploit).", 12)
    return
end

-- Dung loadstring cua executor, neu executor chi co `load` thi dung `load`
local RUNCHUNK = (type(loadstring) == "function") and loadstring or load

-- ==================== TẢI WINDUI ====================
-- 3 link nguồn, cai nao tai duoc thi dung cai do (mang VN hay bi chan link
-- github releases -> co raw + jsdelivr lam duong phong). Loi cu the se hien
-- len man hinh de guoi cho t xem.
local WINDUI_SOURCES = {
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua",
    "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
    "https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
}

local ok = false
local WindUI = nil
local loadErr = "khong thu duoc link nao"

for _, url in ipairs(WINDUI_SOURCES) do
    local oneOk, result = pcall(function()
        local source = game:HttpGet(url, true)
        if type(source) ~= "string" then
            error("HttpGet tra ve " .. type(source))
        end
        if #source < 2000 then
            -- thuong la trang HTML (404 / bi chan) chu khong phai code Lua
            error("bai tai ve qua ngan (" .. #source .. " ky tu), co the la trang loi")
        end
        local chunk, chunkErr = RUNCHUNK(source)
        if not chunk then
            error("loi dong code: " .. tostring(chunkErr))
        end
        local lib = chunk()
        if type(lib) ~= "table" then
            error("WindUI khong tra ve table (" .. type(lib) .. ")")
        end
        return lib
    end)
    if oneOk and type(result) == "table" then
        ok = true
        WindUI = result
        break
    end
    loadErr = tostring(result)
    warn("[H4X Hub] WindUI link loi: " .. url .. " | " .. loadErr)
end

if not ok or type(WindUI) ~= "table" then
    notify("Hub Lỗi", "Ko tải được WindUI (ca 3 link). Lỗi: " .. loadErr:sub(1, 120)
        .. " | Check lại mạng/RAM hoặc executor có cho HttpGet không.", 12)
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==================== THEME HỒNG TÙY CHỈNH ====================
pcall(function()
    WindUI:AddTheme({
        Name = "PinkH4X",
        Accent = Color3.fromRGB(255, 105, 180),
        Dialog = Color3.fromRGB(40, 15, 28),
        Outline = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(210, 170, 190),
        Background = Color3.fromRGB(16, 16, 16),
        Button = Color3.fromRGB(233, 95, 116),
        Icon = Color3.fromRGB(255, 105, 180),
        Toggle = Color3.fromRGB(51, 199, 89),
        Slider = Color3.fromRGB(255, 105, 180),
        Checkbox = Color3.fromRGB(255, 105, 180),
        PanelBackground = Color3.fromRGB(255, 255, 255),
        PanelBackgroundTransparency = 0.95,
        SliderIcon = Color3.fromRGB(255, 105, 180),
        Primary = Color3.fromRGB(255, 105, 180),
        LabelBackground = Color3.fromRGB(0, 0, 0),
        LabelBackgroundTransparency = 0.83,
        ElementBackground = Color3.fromRGB(45, 30, 40),
        ElementBackgroundTransparency = 0,
    })
end)

--==============================================================
-- 📜 CỬA SỔ XEM CODE (tự tạo, ko phụ thuộc WindUI -> chạy trước)
--==============================================================
local COLOR_PRIMARY = Color3.fromRGB(255, 105, 180) -- hồng
local COLOR_WHITE   = Color3.fromRGB(255, 255, 255)
local COLOR_GRAY    = Color3.fromRGB(60, 60, 60)
local COLOR_BG      = Color3.fromRGB(30, 30, 36)
local COLOR_CODE_BG = Color3.fromRGB(22, 22, 27)

local ViewerGui = Instance.new("ScreenGui")
ViewerGui.Name = "H4XDARLING009_CodeViewer"
ViewerGui.ResetOnSpawn = false
ViewerGui.DisplayOrder = 1000000 -- hiện trên tất cả
ViewerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

do
    local guiParent = nil
    pcall(function()
        if gethui then
            guiParent = gethui()
        else
            guiParent = game:GetService("CoreGui")
        end
    end)
    local parented = false
    if guiParent then
        parented = pcall(function()
            ViewerGui.Parent = guiParent
        end)
    end
    if not parented then
        ViewerGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local Viewer = Instance.new("Frame")
Viewer.Name = "CodeViewer"
Viewer.Size = UDim2.new(0, 620, 0, 420)
Viewer.Position = UDim2.new(0.5, -310, 0.5, -210)
Viewer.BackgroundColor3 = COLOR_BG
Viewer.BorderSizePixel = 0
Viewer.Active = true
Viewer.Draggable = true
Viewer.Visible = false
Viewer.Parent = ViewerGui

local ViewerCorner = Instance.new("UICorner")
ViewerCorner.CornerRadius = UDim.new(0, 14)
ViewerCorner.Parent = Viewer

local ViewerStroke = Instance.new("UIStroke")
ViewerStroke.Color = COLOR_PRIMARY
ViewerStroke.Thickness = 2
ViewerStroke.Parent = Viewer

-- Nút đóng
local CloseViewerBtn = Instance.new("TextButton")
CloseViewerBtn.Size = UDim2.new(0, 90, 0, 32)
CloseViewerBtn.Position = UDim2.new(0, 12, 0, 10)
CloseViewerBtn.BackgroundColor3 = COLOR_GRAY
CloseViewerBtn.Text = "← Đóng"
CloseViewerBtn.TextColor3 = COLOR_WHITE
CloseViewerBtn.Font = Enum.Font.SourceSansBold
CloseViewerBtn.TextSize = 14
CloseViewerBtn.Parent = Viewer
local CloseViewerCorner = Instance.new("UICorner")
CloseViewerCorner.CornerRadius = UDim.new(0, 6)
CloseViewerCorner.Parent = CloseViewerBtn

-- Tiêu đề
local ViewerTitle = Instance.new("TextLabel")
ViewerTitle.Size = UDim2.new(1, -230, 0, 32)
ViewerTitle.Position = UDim2.new(0, 112, 0, 10)
ViewerTitle.BackgroundTransparency = 1
ViewerTitle.Text = "📜 Script"
ViewerTitle.TextColor3 = COLOR_WHITE
ViewerTitle.Font = Enum.Font.SourceSansBold
ViewerTitle.TextSize = 16
ViewerTitle.TextXAlignment = Enum.TextXAlignment.Left
ViewerTitle.TextTruncate = Enum.TextTruncate.AtEnd
ViewerTitle.Parent = Viewer

-- Nút chạy
local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0, 80, 0, 32)
RunBtn.Position = UDim2.new(1, -182, 0, 10)
RunBtn.BackgroundColor3 = Color3.fromRGB(60, 170, 90)
RunBtn.Text = "▶ Chạy"
RunBtn.TextColor3 = COLOR_WHITE
RunBtn.Font = Enum.Font.SourceSansBold
RunBtn.TextSize = 14
RunBtn.Parent = Viewer
local RunCorner = Instance.new("UICorner")
RunCorner.CornerRadius = UDim.new(0, 6)
RunCorner.Parent = RunBtn

-- Nút copy
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0, 80, 0, 32)
CopyBtn.Position = UDim2.new(1, -94, 0, 10)
CopyBtn.BackgroundColor3 = COLOR_PRIMARY
CopyBtn.Text = "📋 Copy"
CopyBtn.TextColor3 = COLOR_WHITE
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.TextSize = 14
CopyBtn.Parent = Viewer
local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 6)
CopyCorner.Parent = CopyBtn

-- Khung cuộn code
local CodeScroll = Instance.new("ScrollingFrame")
CodeScroll.Size = UDim2.new(1, -24, 1, -54)
CodeScroll.Position = UDim2.new(0, 12, 0, 48)
CodeScroll.BackgroundColor3 = COLOR_CODE_BG
CodeScroll.BorderSizePixel = 0
CodeScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CodeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
CodeScroll.ScrollBarThickness = 6
CodeScroll.ScrollBarImageColor3 = COLOR_PRIMARY
CodeScroll.Parent = Viewer
local CodeScrollCorner = Instance.new("UICorner")
CodeScrollCorner.CornerRadius = UDim.new(0, 8)
CodeScrollCorner.Parent = CodeScroll

-- Hộp code (chỉ đọc, bôi đen copy tay được)
local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, -16, 0, 0)
CodeBox.Position = UDim2.new(0, 8, 0, 6)
CodeBox.AutomaticSize = Enum.AutomaticSize.Y
CodeBox.BackgroundTransparency = 1
CodeBox.Text = ""
CodeBox.TextColor3 = Color3.fromRGB(220, 225, 235)
CodeBox.Font = Enum.Font.Code
CodeBox.TextSize = 13
CodeBox.TextWrapped = false
CodeBox.MultiLine = true
CodeBox.TextEditable = false
CodeBox.ClearTextOnFocus = false
CodeBox.TextXAlignment = Enum.TextXAlignment.Left
CodeBox.TextYAlignment = Enum.TextYAlignment.Top
CodeBox.Parent = CodeScroll

local viewerUrl = nil
local viewerSource = nil
local viewerBeforeRun = nil
local viewerCopyText = nil -- dùng cho link / bảng giá (copy text thay vì code)

local function OpenViewer(name, url, beforeRun)
    viewerUrl = url
    viewerSource = nil
    viewerBeforeRun = beforeRun
    viewerCopyText = nil
    RunBtn.Visible = true
    CopyBtn.Visible = true
    ViewerTitle.Text = "⏳ " .. name .. " (đang tải...)"
    CodeBox.Text = "-- Đang tải script, đợi nha..."
    Viewer.Visible = true

    task.spawn(function()
        local fetchOk, src = pcall(function()
            return game:HttpGet(url, true)
        end)
        if viewerUrl ~= url then return end -- user đã bấm script khác
        if not fetchOk then
            ViewerTitle.Text = "❌ " .. name
            CodeBox.Text = "-- KHÔNG TẢI ĐƯỢC SCRIPT\n-- Lỗi: " .. tostring(src)
                .. "\n-- Kiểm tra lại link hoặc executor có hỗ trợ HttpGet không."
            return
        end
        viewerSource = src
        ViewerTitle.Text = "📜 " .. name .. "  (" .. #src .. " ký tự)"
        if #src > 16000 then
            CodeBox.Text = src:sub(1, 16000)
                .. "\n\n-- ⚠️ SCRIPT QUÁ DÀI: chỉ hiện 16000 ký tự đầu."
                .. "\n-- Bấm nút [📋 Copy] để lấy TOÀN BỘ code."
        else
            CodeBox.Text = src
        end
    end)
end

-- Hiện 1 đoạn thông tin (link, bảng giá...) + copy được, KHÔNG có nút Chạy
local function ShowInfo(name, text)
    viewerUrl = nil
    viewerSource = nil
    viewerBeforeRun = nil
    viewerCopyText = text
    RunBtn.Visible = false
    CopyBtn.Visible = true
    ViewerTitle.Text = "ℹ️ " .. name
    CodeBox.Text = text
    Viewer.Visible = true
end

CloseViewerBtn.MouseButton1Click:Connect(function()
    Viewer.Visible = false
end)

RunBtn.MouseButton1Click:Connect(function()
    if not viewerUrl then return end
    task.spawn(function()
        local src = viewerSource
        if not src then
            local fetchOk, err = pcall(function()
                src = game:HttpGet(viewerUrl, true)
            end)
            if not fetchOk then
                warn("[Hub] Không tải được script: " .. tostring(err))
                return
            end
        end
        if viewerBeforeRun then
            pcall(viewerBeforeRun)
        end
        local runOk, err = pcall(function()
            RUNCHUNK(src)()
        end)
        if not runOk then
            warn("[Hub] Lỗi chạy script: " .. tostring(err))
        end
    end)
end)

CopyBtn.MouseButton1Click:Connect(function()
    task.spawn(function()
        local src = viewerCopyText
        if not src and viewerUrl then
            src = viewerSource
            if not src then
                local fetchOk = pcall(function()
                    src = game:HttpGet(viewerUrl, true)
                end)
                if not fetchOk then return end
            end
        end
        if not src then return end
        pcall(function()
            if setclipboard then
                setclipboard(src)
            end
        end)
        CopyBtn.Text = "✔ Đã copy"
        task.wait(1.2)
        CopyBtn.Text = "📋 Copy"
    end)
end)

local function collectRoots()
    local roots = {}
    pcall(function()
        if gethui then
            table.insert(roots, gethui())
        end
    end)
    pcall(function()
        table.insert(roots, game:GetService("CoreGui"))
    end)
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then
        table.insert(roots, pg)
    end
    return roots
end

--==============================================================
-- 🪟 MENU WINDUI + CÁC NÚT (trong lồng xpcall: lỗi sẽ báo lên màn hình)
--==============================================================
local WindWindow = nil -- giữ tham chiếu cửa sổ
local cleanUpPerf = nil -- tab "Tăng fps" gán hàm dọn vào đây, shutdownHub sẽ gọi

local buildOk, buildErr = xpcall(function()
    local Window = WindUI:CreateWindow({
        Title = "H4XDARLING009 Hub",
        Icon = "rbxassetid://10723345633",
        Author = "H4XDARLING009",
        Folder = "H4X9 Settings",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = "Dark",
        SideBarWidth = 170,
        HasOutline = true,
        HideSearchBar = not HIEN_O_TIM_KIEM
    })
    WindWindow = Window

    -- Áp theme hồng sau khi cửa sổ đã tạo (an toàn, lỗi thì giữ Dark)
    pcall(function()
        WindUI:SetTheme("PinkH4X")
    end)
    pcall(function()
        local current = WindUI:GetCurrentTheme()
        if current ~= "PinkH4X" then
            WindUI:SetTheme("Rose")
        end
    end)

    local HomeTab = Window:Tab({
        Title = "Trang chủ",
        Icon = "house"
    })

    HomeTab:Paragraph({
        Title = "Cách dùng",
        Desc = "Bấm tên script ở các tab bên trái, cửa sổ mới sẽ hiện TOÀN BỘ CODE bên trong script đó."
            .. " Trong cửa sổ code có nút ▶ Chạy (chạy luôn script) và 📋 Copy (copy toàn bộ code)."
            .. " Nút — trên cửa sổ menu để thu nhỏ thành thanh nhỏ trên cùng, bấm thanh đó để mở lại menu"
            .. " (PC: thanh do hub tự vẽ, kéo được, chuột phải = tắt hub. Mobi: dùng thanh gốc của WindUI, hub ko vẽ thêm -> hết bị 2 thanh)."
            .. " PHIM TAT: bam Left Ctrl mo menu, bam lan nua thu (nham luc giu Ctrl bam C/V/X thi menu tu ve lai, doi phim o dau file)."
            .. " An X tat hub thi menu mat het nhung BOOST FPS + FPS van chay: 2 nut [x] [R] canh dong ho FPS duoc dung thay hub."
            .. " Tab Cai may: nut Boost FPS (Remove Textures) ha QualityLevel + Plastic hoa part + an Decal/Texture,"
            .. " bam [↩ Trả lại cài đặt gốc] hoac nut [R] la ve dung nhu luc dau."
            .. " Ban moi nhat: phim tat chi goi Close/Open cua WindUI khi GUI con song,"
            .. " va neu co loi no tu tat han phim tat -> bam Ctrl sau khi tat hub thi game VAN AN TOAN."
            .. " Trang này luôn có nút Discord / TikTok và bảng giá cày thuê."
    })

    --==============================================================
    -- ⚙️ Tab "Tăng fps" — TẠO SỚM Ở ĐÂY để nó đứng THỨ 2 trên sidebar
    --    (ngay sau Trang chủ). Nội dung + nút bấm của tab này được nhồi
    --    ở khối do ... end bên dưới, sau vòng lặp các tab game.
    --==============================================================
    local PerfTab = Window:Tab({
        Title = "Tăng fps",
        Icon = "gauge"
    })

    --==============================================================
    -- DỮ LIỆU CÁC SCRIPT (giữ nguyên danh sách gốc)
    --==============================================================
    local sections = {
        {
            title = "Blox Fruit",
            icon = "swords",
            buttons = {
                {"RealKid Hub", "https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"},
                {"Redz Hub", "https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Redz/v1.luau"},
                {"Teddy Hub", "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/TeddyHub.lua"},
                {"Quantum Onyx", "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"},
                {"Hermanos Hub (PVP)", "https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"},
                {"HoHo Hub (Freemium)", "https://raw.githubusercontent.com/acsu123/HohoV2/main/ScriptLoad.lua"},
                {"OMG Hub", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"},
                {"bnn test ko use dc ", ""}
            },
        },
        {
            title = "Steal an Egg",
            icon = "egg",
            buttons = {
                {"Lemon Hub", "https://raw.githubusercontent.com/kadit9999/stealanegg/refs/heads/main/lemonhub.lua"},
                {"Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"},
                {"Ajian Hub (Luarmor)", "https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"},
                {"Zeroin Hub", "https://zeroinhub.com/api/script"},
                {"Vezyx Hub", "https://id.tomroblox.com/raw/kairoblox/chilli-x-venyx-viet-hoa-v6-vip-pro98"},
                {"Chili Hub v8", "https://id.tomroblox.com/raw/kairoblox/chilli-x-venyx-v8-finder-free-9836"},
                {"Sena Hub', 'https://raw.githubusercontent.com/senarblx/sena/refs/heads/main/loaderv2sena"},
            },
        },
        {
            title = "TSB",
            icon = "swords",
            buttons = {
                {"Auto farm", "https://gitlab.com/zkay404-group/ProjectYielding/-/raw/main/ZKPublicFarm"},
                {"Jnkie API Script (TSB)", "https://api.jnkie.com/api/v1/luascripts/public/52276846a0d8e73f3208d9206b7be7c8ea031f62e5707d45d0ec9abfdca35467/download"},
                {"Legends Battlegrounds", "https://raw.githubusercontent.com/solarastuff/legendsbattlegrounds/refs/heads/main/legendary.lua"},
                {"Phantasm Hub (TSB)", "https://raw.githubusercontent.com/ATrainz/Phantasm/refs/heads/main/Games/TSB.lua"},
            },
        },
        {
            title = "evade",
            icon = "move",
            buttons = {
                {"Shader map đẹp Hub", "https://raw.githubusercontent.com/zugkun/CustomShader/refs/heads/main/JoevanShaderLite.lua"},
                {"Yinyang Hub", "https://raw.githubusercontent.com/yesimsoul/Yin-Yang-Hub/refs/heads/main/evade"},
                {"Moondiety Hub", "https://moondiety.com/loader"},
                {"Ivory Hub", "https://jnkie.com/loaders/ivory"},
                {"Rift Hub", "https://riftscripts.up.railway.app/api/v1/loader/hlwn-evade"},
                {"Weroshiny Hub v36", "https://raw.githubusercontent.com/syfta8/evade/refs/heads/main/WeroShiny-Hub"},
                {"Auto farm  Hub", "https://raw.githubusercontent.com/gumanba/Scripts/main/EvadeEvent"},
                {"Draconic Hub", "https://raw.githubusercontent.com/Unknownproooolucky/Draconic-Hub-X/refs/heads/main/files/Evade/Overhaul.lua"}

            },
        },
        {
            title = "Fisch",
            icon = "fish",
            buttons = {
                {"Space Hub", "https://raw.githubusercontent.com/ago106/SpaceHub/refs/heads/main/Multi"},
                {"Speed Hub X", "https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
                {"Zenith Hub", "https://raw.githubusercontent.com/Zenith-Devs/Zenith-Hub/main/loader"},
                {"Disch Script V2", "https://raw.githubusercontent.com/hakariqScripts/disch2/refs/heads/main/disch%20script"},
                {"Nat Hub", "https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"},
            },
        },
        {
            title = "King Legacy",
            icon = "crown",
            buttons = {
                {"Tsuo Hub", "https://raw.githubusercontent.com/Tsuo7/TsuoHub/main/king%20legacy"},
                {"Genesis Hub", "https://raw.githubusercontent.com/mainloadergg/GenesisHub/refs/heads/main/KingLegacy.lua"},
                {"OMG Hub", "https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"},
                {"Wukong Hub", "https://raw.githubusercontent.com/duymanhm6-cyber/wukonghud/refs/heads/main/wukonghud"},
            },
        },
        {
            title = "jjs kaisen",
            icon = "crosshair",
            buttons = {
                {"Khanhly Hub", "https://raw.githubusercontent.com/khoavipok/Jjs-khanhly/refs/heads/main/1878725522944274.lua.txt"},
                {"TBO Hub", "https://raw.githubusercontent.com/cool5013/TBO/main/TBOscript"},
                {"Culling Hub", "https://raw.githubusercontent.com/damir512/CullingHubv1.0/refs/heads/main/Cullingotoole.lua"},
                {"jujutsuerV2", "https://raw.githubusercontent.com/solarastuff/tze/refs/heads/main/JujutsuerV2.lua"},
                {"Nameless v12", "https://raw.githubusercontent.com/NeziaReal/jjs/refs/heads/main/main.lua"},
                {"Kktjss hub1", "https://raw.githubusercontent.com/KKT-Dev/KKT-JJS-hub/refs/heads/main/file/JJS%20Hub%20(New%20Vision)"},
                {"jjs legit hub", "https://raw.githubusercontent.com/DevoidedRing/jujutsupuhh/refs/heads/main/LegitHubMaybe"},
            },
        },
        {
            title = "Steal Brainrot",
            icon = "shopping-basket",
            buttons = {
                {"Hanami-Hub", "https://gist.githubusercontent.com/ahjkwl1/b72febbd39910da3f9679889eba268fc/raw/40fcc15b9a34f1411d58ee9554296b0b438dc169/Hanami-Hub"},
                -- Link duoi day 404 (repo m00ndiety/Steal-a-brainrot khong con ton tai tren
                -- GitHub, kiem 25/10/2026) -> bam chi bao loi. Comment lai cho clean menu.
                -- Co link moi thi bo "-- " dau dong va ghi lai nhu ben tren.
                -- {"Moondiety Hub", "https://raw.githubusercontent.com/m00ndiety/Steal-a-brainrot/refs/heads/main/Steal-a-Brainrot"},
                {"RIFT Hub", "https://rifton.top/loader.lua"},
                {"BRAINROT PLICE", "https://loadstring.net/raw/PSH2TOWUGP"},
                {"Chilli Hub", "https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"},
            }
        },
    }            
    for _, section in ipairs(sections) do
        local tab = Window:Tab({
            Title = section.title,
            Icon = section.icon
        })

        for _, item in ipairs(section.buttons) do
            local name = item[1]
            local url = item[2]
            -- Chi cho phep truong thu 3 la HAM (truoc khi chay). Neu vo tinh ghi
            -- true/false o do thi bo qua, de OpenViewer ko bi nhan gia tri sai.
            local beforeRun = (type(item[3]) == "function") and item[3] or nil

            tab:Button({
                Title = name,
                Desc = "Bấm để xem code bên trong script",
                Callback = function()
                    OpenViewer(name, url, beforeRun)
                end
            })
        end
    end

    --==============================================================
    -- ♾ KHONG GIOI HAN TAB (sidebar tu do = vo han)
    -- Thanh tab ben trai cua WindUI THAT RA la ScrollingFrame (cuon duoc),
    -- nhung no an thanh cuon (ScrollBarThickness = 0) nen them tab thu 10, 11..
    -- tu dong bi "mat hut" xuong duoi -> nhin nhu bi gioi han so tab.
    -- Khoi nay:
    --   1) do tong chieu cao danh sach tab, PHONG TO cua so len vua du de hien
    --      HET moi tab (toi da ~86% chieu cao man hinh),
    --   2) neu van chua du (qua nhieu tab) thi BAT thanh cuon mau hong de
    --      keo/cuon chuot xuong duoc.
    --   -> Muon them bao nhieu section cung duoc, khong phai sua gi o day het.
    --==============================================================
    local function fitSidebar()
        pcall(function()
            if not WindWindow then return end
            local ui = WindWindow.UIElements
            local bar = ui and ui.SideBar
            if not bar then return end
            local inner = bar:FindFirstChild("Frame")
            if not inner then return end

            local layout = inner:FindFirstChildOfClass("UIListLayout")
            local contentH = layout and layout.AbsoluteContentSize.Y or 0
            if contentH <= 0 then contentH = inner.AbsoluteSize.Y end
            local visH = bar.AbsoluteSize.Y

            bar.AutomaticCanvasSize = Enum.AutomaticSize.Y
            bar.ScrollingEnabled = true

            if contentH + 12 <= visH then
                -- du cho roi -> khong can lam gi
                bar.ScrollBarThickness = 0
                return
            end

            local main = ui.Main
            local curH = main and main.AbsoluteSize.Y or 460
            local screenY = workspace.CurrentCamera.ViewportSize.Y

            -- WindUI co the dung UIScale (mobi) -> AbsoluteSize != Size.Offset.
            -- Tinh ty le scale ra de cong chieu cao thieu vao Size that, khong
            -- bi hieu ung "phong to dan" sau moi lan goi.
            local sizeY = main and main.Size.Y or UDim.new(0, 460)
            local scaleF = 1
            if sizeY.Scale == 0 and sizeY.Offset > 0 and curH > 0 then
                scaleF = curH / sizeY.Offset
            end

            local wantH = sizeY.Offset + (contentH + 16 - visH) / scaleF
            local maxH = (screenY * 0.86) / scaleF

            if wantH > maxH then
                wantH = maxH
                bar.ScrollBarThickness = 5
                bar.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
                bar.ScrollBarImageTransparency = 0.3
            else
                bar.ScrollBarThickness = 0
            end

            pcall(function()
                WindWindow:SetSize(nil, UDim2.new(main.Size.X.Scale, main.Size.X.Offset, 0, wantH))
            end)
        end)
    end

    -- do 2 lan: layout cua WindUI tinh xong sau vai frame, va khi doi kich thuoc
    -- man hinh (xoay mobi / phong to cua so) thi do lai
    task.spawn(function()
        task.wait(0.4)
        fitSidebar()
        task.wait(1)
        fitSidebar()
    end)
    pcall(function()
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            task.wait(0.25)
            fitSidebar()
        end)
    end)

    --==============================================================
    -- ⚙️ TAB "Tăng fps" — BOOST FPS (Remove Textures)
    -- Nut nay chi ha do hoa MAY CUA BAN: QualityLevel Level01, part = Plastic +
    -- Reflectance 0, an Decal/Texture. KHONG Destroy object nao, khong doi
    -- speed / jump / camera, khong dong ly tinh -> game nao cung cho.
    -- Moi thuoc tinh doi di duoc LUU LAI -> [↩ Trả lại cài đặt gốc] ve dung nhu cu.
    --==============================================================
    do
        local RunService = game:GetService("RunService")

        -- Muon part MOI sinh ra (Blox Fruits doi dao/zone, map load dan) tu dong
        -- bi ha do hoa luon thi de true; de false = chi xu ly 1 lan luc bam nut.
        local TU_XU_LY_PART_MOI = true

        -- [object] = { [ten thuoc tinh] = gia tri cu }  (key yeu -> object bi xoa
        -- thi tu do sạch, treo 10 tieng khong phat bot RAM)
        local record = setmetatable({}, { __mode = "k" })
        local perfOn = false
        local partConn = nil
        local renderOld = nil
        local touched = 0

        -- ghi lai gia tri cu roi moi doi (thu nao doc/ghi duoc moi danh -> ko loi)
        local function setP(obj, prop, value)
            local okRead, old = pcall(function()
                return obj[prop]
            end)
            if not okRead or old == value then
                return
            end
            local m = record[obj]
            if not m then
                m = {}
                record[obj] = m
            end
            if m[prop] == nil then
                m[prop] = old
            end
            local okWrite = pcall(function()
                obj[prop] = value
            end)
            if not okWrite then
                m[prop] = nil
            end
        end

        -- xu ly 1 object: part -> Plastic + khong phan xa; decal/texture -> an di
        local function applyBoost(obj)
            pcall(function()
                if obj:IsA("BasePart") then -- Part, MeshPart, ScriptPart
                    setP(obj, "Material", Enum.Material.Plastic)
                    setP(obj, "Reflectance", 0)
                    touched = touched + 1
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    setP(obj, "Transparency", 1)
                end
            end)
        end

        local function boostFPS()
            if perfOn then
                return "Boost FPS đang bật rồi (đang tự xử lý đồ họa mới). Muốn chạy lại từ đầu thì bấm [↩ Trả lại cài đặt gốc] trước."
            end
            perfOn = true
            touched = 0

            -- 1) QualityLevel = Level01 (lưu giá trị cũ để trả lại được)
            pcall(function()
                renderOld = settings().Rendering.QualityLevel
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)

            -- 2) quat TOAN BO game: part + decal/texture
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                applyBoost(obj)
                count = count + 1
                if count % 400 == 0 then
                    task.wait() -- ko dong bang game khi map qua nhieu object
                end
            end

            -- 3) part/decal sinh sau (doi dao, zone moi) tu xu ly tiep
            if TU_XU_LY_PART_MOI then
                partConn = game.DescendantAdded:Connect(function(obj)
                    if not perfOn then
                        return
                    end
                    applyBoost(obj)
                end)
            end

            local saved = 0
            for _ in pairs(record) do
                saved = saved + 1
            end
            return "✔ ĐÃ BOOST FPS:\n"
                .. "• QualityLevel = Level01 (thấp nhất)\n"
                .. "• " .. touched .. " part -> Material Plastic + Reflectance 0 (đất/đá/nước không còn bóng đổ bóng gương)\n"
                .. "• Decal/Texture -> Transparency 1 (an hoa van, bang hieu, logo; quan ao in hinh cua nguoi khac cung an theo)\n"
                .. (TU_XU_LY_PART_MOI and "• Tu dong xu ly part/decal moi sinh ra (doi dao, zone map)\n"
                    or "• Chi xu ly 1 lan luc bam nut (part moi sinh giu nguyen do hoa)\n")
                .. "\nQuet qua " .. count .. " object, da luu " .. saved
                .. " gia tri cu. Bam [↩ Trả lại cài đặt gốc] la ve dung nhu luc dau.\n"
                .. "KHONG Destroy thu gi, khong doi speed/jump/camera -> ko bi report."
        end

        local function restoreLag()
            if not perfOn then
                return "Chưa bật boost FPS, không có gì để trả lại."
            end
            perfOn = false
            if partConn then
                partConn:Disconnect()
                partConn = nil
            end

            pcall(function()
                settings().Rendering.QualityLevel = renderOld
            end)

            local n = 0
            for obj, props in pairs(record) do
                for prop, oldVal in pairs(props) do
                    pcall(function()
                        obj[prop] = oldVal
                    end)
                    n = n + 1
                end
            end
            record = setmetatable({}, { __mode = "k" })
            touched = 0
            return "✔ Đã trả lại cài đặt gốc (" .. n .. " thuoc tinh da phuc hoi).\n"
                .. "Chat lieu, do phan xa, hoa van/texture va QualityLevel tro ve nhu luc dau.\n"
                .. "Object sinh ra sau luc boost thi van giu nguyen, khong bi pha."
        end

        -- ---------- ĐỒNG HỒ FPS (góc phải dưới, đổi màu theo FPS) ----------
        local perfGui, fpsLabel = nil, nil
        local fpsConn = nil
        local killHudSafe -- khai bao som de nut ben duoi goi duoc (ham that gan o duoi)

        local function buildHud()
            if perfGui then
                perfGui:Destroy()
            end
            perfGui = Instance.new("ScreenGui")
            perfGui.Name = "H4XDARLING009_PerfHud"
            perfGui.ResetOnSpawn = false
            perfGui.IgnoreGuiInset = true
            perfGui.DisplayOrder = 999997
            perfGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            local placed = false
            pcall(function()
                if gethui then
                    perfGui.Parent = gethui()
                else
                    perfGui.Parent = game:GetService("CoreGui")
                end
                placed = true
            end)
            if not placed then
                perfGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            end

            fpsLabel = Instance.new("TextLabel")
            fpsLabel.Parent = perfGui
            fpsLabel.Size = UDim2.new(0, 130, 0, 30)
            fpsLabel.Position = UDim2.new(1, -140, 1, -40)
            fpsLabel.BackgroundTransparency = 1
            fpsLabel.Text = "FPS: --"
            fpsLabel.Font = Enum.Font.GothamBold
            fpsLabel.TextSize = 20
            fpsLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
            fpsLabel.TextStrokeTransparency = 0.5
            fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
            fpsLabel.TextYAlignment = Enum.TextYAlignment.Bottom

            -- 2 nut nho ben canh dong ho FPS: tat hub van dieu khien duoc,
            -- ko can mo menu lai. [x] = an dong ho (giu boost), [R] = tra lai goc.
            local function hudButton(txt, xOff, tip, onClick)
                local b = Instance.new("TextButton")
                b.Parent = perfGui
                b.Size = UDim2.new(0, 28, 0, 28)
                b.Position = UDim2.new(1, xOff, 1, -40)
                b.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
                b.BackgroundTransparency = 0.35
                b.BorderSizePixel = 0
                b.Text = txt
                b.TextColor3 = Color3.fromRGB(255, 255, 255)
                b.Font = Enum.Font.GothamBold
                b.TextSize = 15
                b.AutoButtonColor = true
                local cn = Instance.new("UICorner")
                cn.CornerRadius = UDim.new(1, 0)
                cn.Parent = b
                local st = Instance.new("UIStroke")
                st.Color = Color3.fromRGB(255, 255, 255)
                st.Transparency = 0.65
                st.Thickness = 1
                st.Parent = b
                b.MouseButton1Click:Connect(onClick)
                return b
            end

            hudButton("x", -178, "Tat dong ho FPS (giu nguyen do hoa da boost)", function()
                pcall(killHudSafe)
            end)
            hudButton("R", -212, "Restore: tra lai cai do hoa goc cua game", function()
                pcall(restoreLag)
                pcall(killHudSafe)
            end)

            local frames = 0
            local last = os.clock()
            fpsConn = RunService.RenderStepped:Connect(function()
                -- neu dong ho da bi xoa (tat hub / bam [x]) thi tu ngat ket noi,
                -- khong cham vao fpsLabel da chet -> tranh loi day chuyen
                if fpsLabel == nil or fpsLabel.Parent == nil then
                    if fpsConn then
                        fpsConn:Disconnect()
                        fpsConn = nil
                    end
                    return
                end
                frames = frames + 1
                local now = os.clock()
                local dt = now - last
                if dt >= 0.5 then
                    local fpsValue = math.floor(frames / dt + 0.5)
                    frames = 0
                    last = now
                    pcall(function()
                        fpsLabel.Text = "FPS: " .. fpsValue
                        if fpsValue < 30 then
                            fpsLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                        elseif fpsValue < 60 then
                            fpsLabel.TextColor3 = Color3.fromRGB(255, 210, 80)
                        else
                            fpsLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
                        end
                    end)
                end
            end)
        end

        local function killHud()
            if fpsConn then
                fpsConn:Disconnect()
                fpsConn = nil
            end
            if perfGui then
                perfGui:Destroy()
                perfGui = nil
                fpsLabel = nil
            end
        end
        killHudSafe = killHud

        -- tab khác dùng lại nút —, X, nên hàm dọn này được goi khi tat hub
        cleanUpPerf = function()
            if KEEP_PERF_ON_CLOSE then
                -- an X tat hub = chi don menu, do hoa van boost, FPS van chay
                -- (muon tat FPS / tra lai do thi bam nut [x] [R] ben canh dong ho)
                return
            end
            pcall(restoreLag)
            pcall(killHud)
        end

        -- PerfTab đã được tạo SỚM ở trên (để đứng thứ 2 sau Trang chủ),
        -- khối này chỉ nhồi nút vào tab đó.
        PerfTab:Section({
            Title = "Optimization & Boost"
        })

        PerfTab:Button({
            Title = "Boost FPS (Remove Textures)",
            Desc = "Giảm cấu hình đồ họa xuống mức thấp nhất",
            Callback = function()
                local msg = boostFPS()
                ShowInfo("Tăng fps", msg)
                -- nhu file goc: chay boost la FPS tu dong hien goc phai duoi
                if perfOn and not perfGui then
                    buildHud()
                end
                pcall(function()
                    WindUI:Notify({
                        Title = "FPS Boost",
                        Content = "Đã tối ưu mượt mà!",
                        Duration = 3
                    })
                end)
            end
        })

        PerfTab:Button({
            Title = "↩ Trả lại cài đặt gốc",
            Desc = "Tắt boost, khôi phục đúng chat lieu / hinh in / do phan xa ban đầu",
            Callback = function()
                ShowInfo("Tăng fps", restoreLag())
            end
        })

        PerfTab:Button({
            Title = "📊 Đồng hồ FPS",
            Desc = "Bật/tắt ô đếm FPS góc phải dưới (xanh >60, vàng 30-60, đỏ <30)",
            Callback = function()
                if perfGui then
                    killHud()
                    ShowInfo("Tăng fps", "Đã tắt đồng hồ FPS.")
                else
                    buildHud()
                    ShowInfo("Tăng fps", "Đã bật đồng hồ FPS ở góc phải dưới.")
                end
            end
        })

        PerfTab:Paragraph({
            Title = "Mẹo ngoài script",
            Desc = "Kéo Graphics slider xuống thấp nhất trong menu Esc của Roblox; "
                .. "chơi ở cửa sổ nhỏ thay vì full screen; tắt tab trình duyệt đang phát video; "
                .. "tắt ghi màn hình/overlay Discord. Mỗi cái ăn thêm vài FPS thật."
        })
    end

    --==============================================================
    -- 📞 NÚT LIÊN HỆ (Discord / TikTok) — trong Trang chủ
    -- Roblox KHÔNG tự mở được trang web -> bấm nút là COPY link,
    -- link cũng hiện lên để m dán vào trình duyệt.
    -- (Nút acc Roblox đã XÓA theo yêu cầu 21/10 -> đừng add lại, công khai
    --  tên acc trong hub hay bị soi/report lắm.)
    --==============================================================
    local function ContactButton(tab, title, link, extraDesc)
        tab:Button({
            Title = title,
            Desc = extraDesc,
            Callback = function()
                pcall(function()
                    if setclipboard then
                        setclipboard(link)
                    end
                end)
                ShowInfo(title, link
                    .. "\n\n----------------------------------------"
                    .. "\n✔ Link đã được COPY vào clipboard."
                    .. "\n👉 Dán vào trình duyệt (Ctrl+V rồi Enter) để mở."
                    .. "\n(Roblox không tự mở được trang web nên phải copy thế này.)")
            end
        })
    end

    HomeTab:Paragraph({
        Title = "📞 Liên hệ",
        Desc = "Bấm nút bên dưới là link được copy, dán vào trình duyệt để mở."
    })

    ContactButton(HomeTab, "🎮 Discord Server", "https://discord.gg/4RGnAWArb", "Vào máy chủ Discord của t")
    ContactButton(HomeTab, "📱 TikTok: playercodon009", "https://www.tiktok.com/@playercodon009", "Xem TikTok của t")

    --==============================================================
    -- 💰 BẢNG GIÁ CÀY THUÊ (chữ) — trong Trang chủ
    --==============================================================
    local PRICE_TEXT = [[
💰 BẢNG GIÁ dịch vụ — H4XDARLING009 💰

🔹 lưu ý khi  sử dụng dịch vụ
•giá là bank không phải card /card thì sẽ đắt hơn bank nhé

🔹 VŨ KHÍ / VẬT PHẨM:
• CDK ................. 15K
• YAMA ................ 15K
• TUSHITA ............. 15K
• SCT ................. 20K
• FOX LAMP ............ 30K
• TAM KIEM ............ 8K/1
• TTK ................. 30K
• MO NEO .............. 30K
• DRA STORM ........... 20K
• DRA HEART ........... 15K
• TIM VE TIKI ......... 30K
• TIM VE HYDRA ........ 35K
• FULL ĐẠI (Belt) ..... 25K

🔹 GIÁ NGUYÊN LIỆU (tùy độ hiếm):
• THƯỜNG .............. 10K-15K
• HIẾM ................ 15K-20K
• RẤT HIẾM ............ 20K-25K
• HUYỀN THOẠI ......... 25K
• 99 .................. 10K-25K

🔹 FIGHTING STYLE:
• Melle V2 ............ 10K/1
• Godhuman ............ 25K

🔹 BELI - FRAG:
• 10K = 10M Beli
• 10K = 15K Frag

🔹 UP RARE:
• V1 - V3 ............. 10K
• Cyborg .............. 15K
• Lấy Cyborg .......... 15K
• Up Gear Hóa Hình .... 5K
• Gear 1 .............. 5K
• Gear 2 .............. 10K
• Gear 3 .............. 15K

🔹 DRACO:
• Up Full Gear Draco .. 15K/1 Gear

🔹 LEVEL HAKI (đánh Indra):
• 1K = 70 level
• 1 Haki đánh rip ..... 10K
• 3 Haki đánh rip ..... 30K
• Màu: ĐỎ / HỒNG / TRẮNG

⚠️ LƯU Ý QUAN TRỌNG:
Trong thờI gian cày, AC vui lòng KHÔNG VÔ ACC.
Nếu vô sẽ bị HỦY ĐƠN và KHÔNG HOÀN TIỀN.

💵gamepass và perm fruit
🔹 gamepass blox fruit
•ai cần mua ib discord hoặc tiktok tôi nha
•giá tham khảo có nhu cầu thì mua
•Boats=70k
•x2 Boss Drops=
•+1Fruit Storage=80k
•x2 Mastery=
•x2 Money=90k
•Dark Blade=240k
•Fruit Notifier=530k

🔹perm fruit
•shop đang fix chưa có giá cần thì ib

💵robux 120h
•10k bank=60 robux gamepass
•sau thuế thì còn 42 robux
•lưu ý khi mua phải tạo sẵn gamepass đúng giá mua

📩 Liên hệ đặt đơn:
• Discord: https://discord.gg/4RGnAWArb
• Tiktok: playercodon009
]]

    HomeTab:Button({
        Title = "💰 Bảng giá cày thuê",
        Desc = "Xem toàn bộ giá bằng chữ (bấm 📋 Copy để copy)",
        Callback = function()
            ShowInfo("Bảng giá cày thuê", PRICE_TEXT)
        end
    })
end, function(e)
    return e
end)

if not buildOk then
    -- Dọn cửa sổ WindUI bị dở (nếu có) để khỏi treo cái khung đen
    pcall(function()
        for _, root in ipairs(collectRoots()) do
            for _, sg in ipairs(root:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Name == "WindUI" then
                    sg:Destroy()
                end
            end
        end
    end)
    notify("Hub bị lỗi", "Chụp dòng này gửi t: " .. tostring(buildErr):sub(1, 140), 15)
    warn("[H4X Hub] LOI: " .. tostring(buildErr))
    return
end

-- Mọi thứ ok: nút — hoặc X ẩn menu -> hiện THANH NHỎ bo góc trên cùng, bấm thanh đó mở lại menu
-- (WindUI trên PC ko tự hiện nút mở lại, nên tự tạo thanh pill.
--  CÒN trên MOBI/màn hình cảm ứng, WindUI TỰ hiện pill gốc của nó rồi -> nếu vẽ
--  pill của mình thêm nữa là thành 2 cái trùng nhau (như ảnh Evade). Vì vậy máy
--  cảm ứng = ko vẽ pill riêng, dùng pill gốc của WindUI.)
local isTouchDevice = false
pcall(function()
    local UIS = game:GetService("UserInputService")
    isTouchDevice = (UIS.TouchEnabled == true) and (UIS.KeyboardEnabled ~= true)
end)

-- Do tay neu khong muon dung "tu dong":
--   "tu dong" = PC ve pill rieng, mobi KO ve  (mack dinh -> mobi con 1 thanh)
--   "bat"     = luc nao cung ve pill rieng    (mobi se thay 2 thanh trung nhau)
--   "tat"     = khong ve pill rieng bao gio   (PC phai mo lai bang Left Ctrl)
local CUSTOM_PILL_MODE = "tu dong"

local function pillShouldShow()
    if CUSTOM_PILL_MODE == "tat" then
        return false
    elseif CUSTOM_PILL_MODE == "bat" then
        return true
    end
    return (isTouchDevice ~= true)
end

local PillGui = Instance.new("ScreenGui")
PillGui.Name = "H4XDARLING009_Pill"
PillGui.ResetOnSpawn = false
PillGui.DisplayOrder = 999999
PillGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
do
    local guiParent = nil
    pcall(function()
        if gethui then
            guiParent = gethui()
        else
            guiParent = game:GetService("CoreGui")
        end
    end)
    local parented = false
    if guiParent then
        parented = pcall(function()
            PillGui.Parent = guiParent
        end)
    end
    if not parented then
        PillGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local Pill = Instance.new("Frame")
Pill.Name = "OpenPill"
Pill.Size = UDim2.new(0, 320, 0, 48)
Pill.Position = UDim2.new(0.5, 0, 0, 28)
Pill.AnchorPoint = Vector2.new(0.5, 0.5)
Pill.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Pill.BackgroundTransparency = 0.12
Pill.BorderSizePixel = 0
Pill.Visible = false
Pill.Parent = PillGui

-- bo tròn hết cỡ giống nút gốc của WindUI
local PillCorner = Instance.new("UICorner")
PillCorner.CornerRadius = UDim.new(1, 0)
PillCorner.Parent = Pill

-- viền mảnh có gradient xanh -> hồng giống nút gốc
local PillStroke = Instance.new("UIStroke")
PillStroke.Color = Color3.fromRGB(255, 255, 255)
PillStroke.Transparency = 0.15
PillStroke.Thickness = 1.2
PillStroke.Parent = Pill
local StrokeGrad = Instance.new("UIGradient")
StrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(64, 201, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(232, 28, 255)),
})
StrokeGrad.Parent = PillStroke

-- ô vuông bên TRÁI có icon 4 mũi tên + vạch chia, y hệt pill gốc trên mobi
local PILL_ICON_W = 48
local PillIconBox = Instance.new("Frame")
PillIconBox.Name = "IconBox"
PillIconBox.Size = UDim2.new(0, PILL_ICON_W, 1, 0)
PillIconBox.BackgroundTransparency = 1
PillIconBox.BorderSizePixel = 0
PillIconBox.ZIndex = 3
PillIconBox.Parent = Pill

-- Icon 4 mui ten: VIET BANG HINH (khong dung ky tu ✥ nua -> font Roblox khong co,
-- hien thanh o vuong nhu ban PC vua chup). Gom 2 canh chu thap + 4 dau mui.
local PINK_ICON = Color3.fromRGB(255, 105, 180)
local iconCx, iconCy = PILL_ICON_W / 2, 24 -- tam o icon (pill cao 48)
local iconR, iconT, iconArm = 9, 2, 5

local PillIcon = Instance.new("Frame")
PillIcon.Name = "MoveIcon"
PillIcon.Size = UDim2.new(1, 0, 1, 0)
PillIcon.BackgroundTransparency = 1
PillIcon.BorderSizePixel = 0
PillIcon.ZIndex = 4
PillIcon.Parent = PillIconBox

local function iconBar(px, py, len, thick, rot)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, len, 0, thick)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0, px, 0, py)
    f.Rotation = rot
    f.BackgroundColor3 = PINK_ICON
    f.BorderSizePixel = 0
    f.ZIndex = 4
    f.Parent = PillIcon
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, math.floor(thick / 2))
    c.Parent = f
    return f
end

-- 2 canh chu thap
iconBar(iconCx, iconCy, iconR * 2 + 2, iconT, 0) -- ngang
iconBar(iconCx, iconCy, iconR * 2 + 2, iconT, 90) -- doc

-- 4 dau mui (moi dau = 2 nanh 45 do)
for _, dir in ipairs({ 0, 90, 180, 270 }) do
    local rad = math.rad(dir)
    local tx = iconCx + iconR * math.cos(rad)
    local ty = iconCy + iconR * math.sin(rad)
    for _, off in ipairs({ 135, -135 }) do
        local a = math.rad(dir + off)
        -- diem neo = dau nanh, tinh tam frame roi doi ra (AnchorPoint 0.5)
        local ax = tx + (iconArm / 2) * math.cos(a)
        local ay = ty + (iconArm / 2) * math.sin(a)
        iconBar(ax, ay, iconArm, iconT, dir + off)
    end
end

local PillSplit = Instance.new("Frame")
PillSplit.Name = "Split"
PillSplit.Size = UDim2.new(0, 1, 0, 26)
PillSplit.Position = UDim2.new(0, PILL_ICON_W, 0.5, 0)
PillSplit.AnchorPoint = Vector2.new(0.5, 0.5)
PillSplit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PillSplit.BackgroundTransparency = 0.78
PillSplit.BorderSizePixel = 0
PillSplit.ZIndex = 3
PillSplit.Parent = Pill

-- nút bấm trong suốt phủ kín pill (bấm mở menu + kéo thả)
local PillBtn = Instance.new("TextButton")
PillBtn.Name = "Hit"
PillBtn.Size = UDim2.new(1, 0, 1, 0)
PillBtn.BackgroundTransparency = 1
PillBtn.Text = "H4XDARLING009 Hub"
PillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PillBtn.Font = Enum.Font.GothamMedium
PillBtn.TextSize = 18
PillBtn.AutoButtonColor = false
PillBtn.ZIndex = 2
PillBtn.Parent = Pill

-- det chu sang ben phai o icon (de giong pill goc: icon | ten)
local PillPad = Instance.new("UIPadding")
PillPad.PaddingLeft = UDim.new(0, PILL_ICON_W + 6)
PillPad.Parent = PillBtn

--==============================================================
-- 🛡️ hubAlive + GUI WindUI
-- Loi cu "bam Ctrl sau khi tat hub -> dong Roblox" den tu 2 chuyen:
--   (1) goi WindWindow:Open()/Close() luc GUI da bi Destroy;
--   (2) ta TU Destroy ScreenGui cua WindUI ma khong cho WindUI cat cac ket noi
--       noi bo cua no (kéo window, phim, tween) -> WindUI van chay tiep tren
--       do da chet, bam phim la noi chien day chuyen.
-- Cach nay:
--   - nut — / pill van goi Open/Close GOC cua WindUI (dung hieu ung + pill cua no),
--     nhung chi goi khi hubAlive = true;
--   - khi tat hub thi goi Destroy GOC cua WindUI TRUOC de tu no don minh,
--     ta chi don pill + cua so code cua ta;
--   - ngay sau khi GUI bi xoa thi hubAlive = false va phim tat bi cat ket noi,
--     nen Ctrl khong con duong nao goi vao WindUI nua.
--==============================================================
local hubAlive = true
local onHubShutdown = nil -- chỗ này cho block phím tat gan vao de cat ket noi
local windGui = nil
local menuOpen = true -- WindUI mo cửa sổ ngay khi CreateWindow
local windGuiWatched = false
local windGuis = {} -- moi ScreenGui "WindUI" tim thay (WindUI tao nhieu hon 1 cai)

local origOpen = nil
local origClose = nil
local origDestroy = nil

local function scanWindGuis()
    local list = {}
    for _, root in ipairs(collectRoots()) do
        pcall(function()
            for _, sg in ipairs(root:GetChildren()) do
                if sg:IsA("ScreenGui") and sg.Name == "WindUI" then
                    table.insert(list, sg)
                end
            end
        end)
    end
    if #list > 0 then
        windGuis = list
    end
    return windGuis
end

-- Co con ScreenGui WindUI nao song khong? (khong dung .Visible cua 1 cai de
-- doan, vi WindUI co the co nhieu ScreenGui cung ten)
local function windGuiAlive()
    for _, sg in ipairs(windGuis) do
        local live = false
        pcall(function()
            live = (sg.Parent ~= nil)
        end)
        if live then
            return true
        end
    end
    scanWindGuis()
    for _, sg in ipairs(windGuis) do
        local live = false
        pcall(function()
            live = (sg.Parent ~= nil)
        end)
        if live then
            return true
        end
    end
    return false
end

local function findWindGui()
    local list = scanWindGuis()
    return list[#list]
end

-- An toan bo GUI WindUI con song (dung khi tat hub, khong cho no loe ra nua)
local function hideWindGui()
    scanWindGuis()
    for _, sg in ipairs(windGuis) do
        pcall(function()
            if sg.Parent ~= nil then
                sg.Visible = false
            end
        end)
    end
end

-- Lay ham GOC cua WindUI TRUOC khi bi ghi de (phai lay o day, duoi nua la
-- ham cua hub roi goi lai se de quy)
do
    pcall(function()
        if WindWindow then
            if type(WindWindow.Open) == "function" then
                origOpen = WindWindow.Open
            end
            if type(WindWindow.Close) == "function" then
                origClose = WindWindow.Close
            end
            if type(WindWindow.Destroy) == "function" then
                origDestroy = WindWindow.Destroy
            end
        end
    end)
    if not windGuiAlive() then
        windGui = findWindGui()
    end
end

local function isPillVisible()
    local vis = false
    pcall(function()
        vis = (PillGui.Parent ~= nil) and (Pill.Visible == true)
    end)
    return vis == true
end

local function setPillShown(show)
    pcall(function()
        if PillGui.Parent ~= nil then
            Pill.Visible = (show == true)
        end
    end)
end

--==============================================================
-- ❌ TẮT HẲN HUB (X / chuột phải pill / GUI WindUI bi xoa)
-- Don theo tung buoc, moi buoc cach 1 frame, AN MENU TRUOC ROI MOI XOA
-- -> khong xoa GUI giua luc WindUI dang ve (do la 1 cach gay vung game).
--==============================================================
local function shutdownHub()
    if not hubAlive then
        return
    end
    hubAlive = false

    -- 1) ngat ket noi phim tat DAU TIEN tien (kha nang gay loi lon nhat)
    pcall(function()
        if onHubShutdown then
            onHubShutdown()
        end
    end)
    -- 2) lưu ý ve do hoa (KEEP_PERF_ON_CLOSE = true thi khong lam gi)
    pcall(function()
        if cleanUpPerf then
            cleanUpPerf()
        end
    end)
    -- 3) cho WindUI TU don cua no (cat ket noi keo cua / tween / phim cua no).
    --    Day la buoc quyet dinh: truoc day ta xoa thang ScreenGui cua WindUI ->
    --    code noi bo cua van con chay tren do da chet -> bam Ctrl la vung game.
    pcall(function()
        if origDestroy and WindWindow then
            origDestroy(WindWindow)
        end
    end)
    -- 4) an het GUI WindUI con sot lai (phong hien tuong xoa khong het)
    hideWindGui()

    -- 5) don cua cua minh theo tung buoc, cach nhau 1 frame
    task.spawn(function()
        task.wait()
        pcall(function()
            if PillGui.Parent ~= nil then
                PillGui:Destroy()
            end
        end)
        task.wait()
        pcall(function()
            if ViewerGui.Parent ~= nil then
                ViewerGui:Destroy()
            end
        end)
        task.wait()
        for _, root in ipairs(collectRoots()) do
            if not KEEP_PERF_ON_CLOSE then
                pcall(function()
                    local hud = root:FindFirstChild("H4XDARLING009_PerfHud", true)
                    if hud then
                        hud:Destroy()
                    end
                end)
            end
            -- chi xoa khi WindUI chua tu xoa (origDestroy o buoc 3 thuong da xoa roi)
            pcall(function()
                for _, sg in ipairs(root:GetChildren()) do
                    if sg:IsA("ScreenGui") and sg.Name == "WindUI" and sg.Parent ~= nil then
                        sg:Destroy()
                    end
                end
            end)
        end
    end)
    -- (khong pop-up thong bao o day nua -> chi in ra executor cho de debug)
    print("[H4X Hub] da tat hub")
end

--==============================================================
-- 🪟 AN / MO MENU
-- Goi Open/Close GOC cua WindUI -> menu thu vao pill cua chinh no, dung hieu
-- ung. (Ban truoc do ta chi flip .Visible cua 1 ScreenGui ten "WindUI", nhung
-- WindUI tao NHIEU ScreenGui cung ten -> an nham cai khong phai cua so: bam —
-- thi menu van nguyen + mo thanh pill cua hub ra thanh 2 lop nhu ban chup.)
-- Van an toan chet game: chi goi khi hubAlive = true VA con ScreenGui WindUI
-- song; WindUI ma loi dong/mo thi ta tat hub luon, khong thu lan 2.
--==============================================================
local applyingMenu = false

-- Gan theo doi Destroy cho TAT CA ScreenGui "WindUI": WindUI tu xoa GUI bang
-- duong nao khong qua nut X cua hub thi hubAlive bi dat false lap tuc, phim tat
-- / pill khong con cham vao do da chet nua.
local function watchWindGuis()
    if windGuiWatched then
        return
    end
    scanWindGuis()
    if #windGuis == 0 then
        return
    end
    windGuiWatched = true
    for _, sg in ipairs(windGuis) do
        pcall(function()
            sg.Destroyed:Connect(function()
                shutdownHub()
            end)
        end)
    end
end

local function setMenuShown(show)
    if not hubAlive or applyingMenu then
        return false
    end
    if not windGuiAlive() then
        -- khong con GUI WindUI = hub da tat that -> tat phim tat, dung tai day
        shutdownHub()
        return false
    end
    watchWindGuis()

    applyingMenu = true
    local didCall = false
    local okCall = false
    if show and origOpen ~= nil then
        didCall = true
        okCall = pcall(origOpen, WindWindow)
    elseif (not show) and origClose ~= nil then
        didCall = true
        okCall = pcall(origClose, WindWindow)
    end
    if didCall and not okCall then
        -- WindUI loi khi dong/mo cua = no khong con on -> tat hub bao ve game
        applyingMenu = false
        shutdownHub()
        return false
    end
    if not didCall then
        -- WindUI ban khong co Open/Close -> phong su: chi an/hien ScreenGui
        scanWindGuis()
        for _, sg in ipairs(windGuis) do
            pcall(function()
                if sg.Parent ~= nil then
                    sg.Visible = show
                end
            end)
        end
    end
    applyingMenu = false
    menuOpen = show
    -- pill cua hub chi hien khi menu da thu (mobi: WindUI tu co pill cua no)
    setPillShown((not show) and pillShouldShow())
    return true
end

windGui = findWindGui()
watchWindGuis()

-- Vong do sat: 0.5s check 1 lan. Moi ScreenGui WindUI deu mat ma hubAlive con
-- true (WindUI tu xoa GUI luc script chua kip gan theo doi) -> tat hub luon,
-- de phim tat khong bao gio con goi vao do da chet.
task.spawn(function()
    while hubAlive do
        task.wait(0.5)
        if not hubAlive then
            break
        end
        if not windGuiAlive() then
            shutdownHub()
            break
        end
    end
end)

--==============================================================
-- 👆 PILL: bấm trái mở lại menu + kéo thả (kéo ra chỗ khác cho đỡ vướng)
--==============================================================
do
    local dragging = false
    local dragMoved = false
    local dragStart = nil
    local startPos = nil

    PillBtn.InputBegan:Connect(function(input)
        if not hubAlive then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            -- de sang frame sau moi xoa: Destroy giua luc chinh no dang phat
            -- su kien InputBegan la 1 cach gay loi day chuyen
            task.defer(shutdownHub)
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragMoved = false
            dragStart = input.Position
            startPos = Pill.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    PillBtn.InputChanged:Connect(function(input)
        if not hubAlive then
            return
        end
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 6 then
                dragMoved = true -- đã kéo, lần thả này ko tính là bấm
            end
            pcall(function()
                if PillGui.Parent ~= nil then
                    Pill.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
    end)

    PillBtn.MouseButton1Click:Connect(function()
        if dragMoved then
            return
        end
        setMenuShown(true)
    end)
end

--==============================================================
-- Ghi đè Open/Close/Destroy của WindUI de dong bo thanh pill cua hub.
-- Ca 3 deu di qua setMenuShown / shutdownHub, la 2 cho duy nhat duoc phep
-- cham vao ham goc cua WindUI (va ca 2 deu kiem tra hubAlive + GUI con song).
-- Nho vay: bam — = WindUI tu thu menu vao pill cua no (dung hieu ung),
-- bam X = WindUI tu don no truoc, roi hub moi don cua hub.
--==============================================================
if WindWindow then
    pcall(function()
        WindWindow.Close = function()
            setMenuShown(false)
        end
        WindWindow.Open = function()
            setMenuShown(true)
        end
        WindWindow.Destroy = function()
            -- tat han hub: shutdownHub goi origDestroy cua WindUI truoc khi don
            task.defer(shutdownHub)
        end
    end)
end


do
    local okUIS, UserInputService = pcall(function()
        return game:GetService("UserInputService")
    end)
    if not okUIS or not UserInputService then
        warn("[H4X Hub] Khong lay duoc UserInputService -> phim tat menu khong chay")
        return
    end

    local keySet = {}
    for _, k in ipairs(MENU_TOGGLE_KEYS) do
        keySet[k] = true
    end
    local CLICK_TYPES = {
        [Enum.UserInputType.MouseButton1] = true,
        [Enum.UserInputType.MouseButton2] = true,
        [Enum.UserInputType.Touch] = true,
    }

    local heldKey = nil -- dang giu phim tat
    local canRevert = false -- van con co the hoan lai lan bam vua roi
    local hotkeyErrors = 0
    local lastToggleAt = 0
    local toggling = false -- chong de quy / chong bam lien tuc

    local connBegan, connEnded

    local function isTyping()
        local ok, box = pcall(function()
            return UserInputService:GetFocusedTextBox()
        end)
        return (ok and box ~= nil)
    end

    -- Cat ket noi phim tat. KHONG dat hubAlive = false o day: khi loi phim tat
    -- thi hub van song (nut — , X, thanh pill van dung duoc). Khi tat hub thi
    -- shutdownHub da tu dat hubAlive = false truoc khi goi ham nay.
    local function killHotkeys(reason)
        pcall(function()
            if connBegan then
                connBegan:Disconnect()
                connBegan = nil
            end
        end)
        pcall(function()
            if connEnded then
                connEnded:Disconnect()
                connEnded = nil
            end
        end)
        heldKey = nil
        canRevert = false
        if reason then
            warn("[H4X Hub] phim tat da tat: " .. tostring(reason))
            notify("H4X Hub", "Da tat phim tat (" .. tostring(reason)
                .. "). Menu van mo/thu duoc bang thanh pill.", 6)
        end
    end

    local function toggleMenu()
        if not hubAlive or toggling then
            return
        end
        -- thu menu = menu dang mo VA thanh pill dang an
        local shouldOpen = (not menuOpen) or isPillVisible()
        -- setMenuShown chi cham vao .Visible cua ScreenGui that;
        -- GUI mat thi tu shutdownHub + cat phim tat -> khong the gay chet game
        setMenuShown(shouldOpen)
    end

    local function runGuarded(fn)
        if not hubAlive then
            return
        end
        -- khong con ScreenGui WindUI nao song = hub da tat: tat phim tat,
        -- khong goi bat cu thu gi nua (day la duong gay chet Roblox cu)
        if not windGuiAlive() then
            shutdownHub()
            return
        end
        toggling = true
        local ok, err = pcall(fn)
        toggling = false
        if ok then
            hotkeyErrors = 0 -- chay xong ngon lanh -> tinh lai tu dau
            return
        end
        hotkeyErrors = hotkeyErrors + 1
        warn("[H4X Hub] phim tat loi lan " .. hotkeyErrors .. ": " .. tostring(err))
        if hotkeyErrors >= 2 then
            -- loi 2 lan = khong cho bam phim tat nua (chi cat ket noi phim,
            -- GIU menu chay tiep) -> game khong the bi vung/đóng vi no
            killHotkeys("loi phim tat -> da tu tat de bao ve game")
        end
    end

    connBegan = UserInputService.InputBegan:Connect(function(input)
        if not hubAlive then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Keyboard
            and not CLICK_TYPES[input.UserInputType] then
            return
        end
        -- chong bam lien tuc gay de quy
        if os.clock() - lastToggleAt < 0.12 then
            return
        end

        if keySet[input.KeyCode] then
            if heldKey or isTyping() then
                return
            end
            heldKey = input.KeyCode
            canRevert = true
            lastToggleAt = os.clock()
            runGuarded(toggleMenu)
            return
        end

        -- giu Ctrl + bam thu khac (C, V, X, Z, A, click...) -> hoan lai lan bam Ctrl
        if heldKey and canRevert then
            local isOtherKey = (input.UserInputType == Enum.UserInputType.Keyboard)
                or CLICK_TYPES[input.UserInputType]
            if isOtherKey then
                canRevert = false
                lastToggleAt = os.clock()
                runGuarded(toggleMenu) -- bam lai 1 lan nua = ve dung trang thai cu
            end
        end
    end)

    connEnded = UserInputService.InputEnded:Connect(function(input)
        if hubAlive and heldKey and input.KeyCode == heldKey then
            heldKey = nil
            canRevert = false
        end
    end)

    -- shutdownHub() goi cai nay: ngat ket noi ngay khi tat hub
    onHubShutdown = function()
        killHotkeys(nil)
    end

    print("[H4X Hub] phim tat menu: Left Ctrl (mo/thu) -- san sang cho phat khac trong MENU_TOGGLE_KEYS")
    -- (bo pop-up "Phim tat: Left Ctrl" -> khong xuong thong bao nua)
end

-- Mọi thứ ok: báo phiên bản
notify("H4XDARLING009 Hub", "v3.67", 4)
print("[H4X Hub] v3.67")
