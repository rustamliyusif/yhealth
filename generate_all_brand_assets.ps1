Add-Type -AssemblyName System.Drawing

function Create-RoundedRectanglePath([float]$x, [float]$y, [float]$width, [float]$height, [float]$radius) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diameter = $radius * 2.0
    $path.AddArc($x, $y, $diameter, $diameter, 180, 90)
    $path.AddArc($x + $width - $diameter, $y, $diameter, $diameter, 270, 90)
    $path.AddArc($x + $width - $diameter, $y + $height - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc($x, $y + $height - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

# ----------------------------------------------------------------------------------
# MASTER VITA-Y SYMBOL VECTOR ENGINE
# Draws the symbol with center at ($cx, $cy), scaled by $scale
# ----------------------------------------------------------------------------------
function Draw-VitaYSymbol($g, [float]$cx, [float]$cy, [float]$scale, [string]$theme) {
    $isDark = ($theme -eq "dark" -or $theme -eq "transparent_dark")

    $state = $g.Save()
    $g.TranslateTransform($cx, $cy)
    $g.ScaleTransform($scale, $scale)

    $stemW = 48.0   # Width of each side
    $gap = 7.0      # Half-gap (total gap = 14)
    $botY = 260.0
    $juncY = -15.0

    # 1. Left Wing (Pure White in Dark mode, Deep Forest in Light mode)
    $pL = New-Object System.Drawing.Drawing2D.GraphicsPath
    $outLX = - ($gap + $stemW)
    $inLX  = - $gap
    $botR  = 24.0

    # Inner wing curve from inner junction (-gap, juncY) up to inner tip (-172, -265)
    $pL.AddBezier(
        [System.Drawing.PointF]::new($inLX, $juncY),
        [System.Drawing.PointF]::new(-70.0, -80.0),
        [System.Drawing.PointF]::new(-140.0, -180.0),
        [System.Drawing.PointF]::new(-172.0, -265.0)
    )
    # Top-left rounded cap to outer tip (-232, -235)
    $pL.AddBezier(
        [System.Drawing.PointF]::new(-172.0, -265.0),
        [System.Drawing.PointF]::new(-192.0, -295.0),
        [System.Drawing.PointF]::new(-238.0, -270.0),
        [System.Drawing.PointF]::new(-232.0, -235.0)
    )
    # Outer wing curve down to outer stem (outLX, juncY + 40)
    $pL.AddBezier(
        [System.Drawing.PointF]::new(-232.0, -235.0),
        [System.Drawing.PointF]::new(-165.0, -110.0),
        [System.Drawing.PointF]::new($outLX, -20.0),
        [System.Drawing.PointF]::new($outLX, $juncY + 40.0)
    )
    # Down along outer edge of stem
    $pL.AddLine($outLX, $juncY + 40.0, $outLX, $botY - $botR)
    # Bottom-left rounded corner
    $pL.AddArc($outLX, $botY - ($botR * 2.0), ($botR * 2.0), ($botR * 2.0), 90, 90)
    # Bottom edge to inner seam
    $pL.AddLine($outLX + $botR, $botY, $inLX, $botY)
    # Up along inner seam to junction
    $pL.AddLine($inLX, $botY, $inLX, $juncY)
    $pL.CloseFigure()

    $brushL = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 38, 25))
    }
    $g.FillPath($brushL, $pL)
    $brushL.Dispose()
    $pL.Dispose()

    # 2. Right Wing (Vital Emerald to Mint Gradient)
    $pR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $outRX = $gap + $stemW
    $inRX  = $gap

    $pR.AddBezier(
        [System.Drawing.PointF]::new($inRX, $juncY),
        [System.Drawing.PointF]::new(70.0, -80.0),
        [System.Drawing.PointF]::new(140.0, -180.0),
        [System.Drawing.PointF]::new(172.0, -265.0)
    )
    $pR.AddBezier(
        [System.Drawing.PointF]::new(172.0, -265.0),
        [System.Drawing.PointF]::new(192.0, -295.0),
        [System.Drawing.PointF]::new(238.0, -270.0),
        [System.Drawing.PointF]::new(232.0, -235.0)
    )
    $pR.AddBezier(
        [System.Drawing.PointF]::new(232.0, -235.0),
        [System.Drawing.PointF]::new(165.0, -110.0),
        [System.Drawing.PointF]::new($outRX, -20.0),
        [System.Drawing.PointF]::new($outRX, $juncY + 40.0)
    )
    $pR.AddLine($outRX, $juncY + 40.0, $outRX, $botY - $botR)
    $pR.AddArc($outRX - ($botR * 2.0), $botY - ($botR * 2.0), ($botR * 2.0), ($botR * 2.0), 0, 90)
    $pR.AddLine($outRX - $botR, $botY, $inRX, $botY)
    $pR.AddLine($inRX, $botY, $inRX, $juncY)
    $pR.CloseFigure()

    $rectGradR = [System.Drawing.RectangleF]::new(0.0, -295.0, 250.0, ($botY + 300.0))
    $brushR = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGradR,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint #34D399 (Athletic Vitality)
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald #10B981 (Health & Life)
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPath($brushR, $pR)
    $brushR.Dispose()
    $pR.Dispose()

    # 3. Cardio Diamond Core (The Vital Pulse in the V-Junction)
    $diaSize = 18.0
    $diaY = $juncY - 14.0
    $pDia = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pDia.AddPolygon([System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(0.0, $diaY - $diaSize),
        [System.Drawing.PointF]::new($diaSize, $diaY),
        [System.Drawing.PointF]::new(0.0, $diaY + $diaSize),
        [System.Drawing.PointF]::new(-$diaSize, $diaY)
    ))
    $diaRect = [System.Drawing.RectangleF]::new(-$diaSize, ($diaY - $diaSize), ($diaSize * 2.0), ($diaSize * 2.0))
    $brushDia = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $diaRect,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($brushDia, $pDia)
    $brushDia.Dispose()
    $pDia.Dispose()

    $g.Restore($state)
}

# ----------------------------------------------------------------------------------
# RENDER SQUIRCLE ICON
# ----------------------------------------------------------------------------------
function Render-IconSquircle([int]$size, [string]$outputPath) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $margin = [float]($size * 0.045)
    $w = [float]($size - (2.0 * $margin))
    $radius = [float]($w * 0.235)
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = [System.Drawing.RectangleF]::new($margin, $margin, $w, $w)

    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 38, 25), # #0B2619 Deep Forest
        [System.Drawing.Color]::FromArgb(255, 4, 16, 11),  # #04100B Obsidian
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()

    if ($size -ge 72) {
        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(26, 255, 255, 255), [float]($size * 0.002))
        $innerPath = Create-RoundedRectanglePath ($margin + 1.0) ($margin + 1.0) ($w - 2.0) ($w - 2.0) ($radius - 1.0)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    }
    $sqPath.Dispose()

    # Draw Symbol
    $scale = [float]($size / 1024.0) * 1.05
    Draw-VitaYSymbol $g ($size / 2.0) ($size / 2.0) $scale "dark"

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ----------------------------------------------------------------------------------
# RENDER ROUND ICON
# ----------------------------------------------------------------------------------
function Render-IconRound([int]$size, [string]$outputPath) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $margin = [float]($size * 0.035)
    $d = [float]($size - (2.0 * $margin))
    $rect = [System.Drawing.RectangleF]::new($margin, $margin, $d, $d)

    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 38, 25),
        [System.Drawing.Color]::FromArgb(255, 4, 16, 11),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillEllipse($bgBrush, $rect)
    $bgBrush.Dispose()

    if ($size -ge 72) {
        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(26, 255, 255, 255), [float]($size * 0.002))
        $g.DrawEllipse($rimPen, $margin + 1.0, $margin + 1.0, $d - 2.0, $d - 2.0)
        $rimPen.Dispose()
    }

    # Draw Symbol slightly smaller for circle safe zone
    $scale = [float]($size / 1024.0) * 0.98
    Draw-VitaYSymbol $g ($size / 2.0) ($size / 2.0) $scale "dark"

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ----------------------------------------------------------------------------------
# RENDER ADAPTIVE FOREGROUND (Transparent background, centered in 66% safe zone)
# ----------------------------------------------------------------------------------
function Render-AdaptiveForeground([int]$size, [string]$outputPath) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # In Android adaptive icons, 108dp has 72dp safe zone = 66.7%
    # We scale the symbol to sit comfortably inside the 60% safe zone
    $scale = [float]($size / 1024.0) * 0.88
    Draw-VitaYSymbol $g ($size / 2.0) ($size / 2.0) $scale "dark"

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ----------------------------------------------------------------------------------
# RENDER HIGH-RES LOGO WITH WORDMARK (1600x500)
# ----------------------------------------------------------------------------------
function Render-WordmarkPackage([string]$outputPath, [string]$theme) {
    $width = 1600
    $height = 500
    $bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $isDark = ($theme -eq "dark")

    $rect = [System.Drawing.RectangleF]::new(0.0, 0.0, $width, $height)
    if ($isDark) {
        $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $rect,
            [System.Drawing.Color]::FromArgb(255, 11, 38, 25),
            [System.Drawing.Color]::FromArgb(255, 4, 16, 11),
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        )
        $g.FillRectangle($bgBrush, $rect)
        $bgBrush.Dispose()
    } else {
        $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 246, 250, 248))
        $g.FillRectangle($bgBrush, $rect)
        $bgBrush.Dispose()
    }

    # Draw Symbol on Left
    Draw-VitaYSymbol $g 260.0 250.0 0.68 $theme

    # Wordmark Typography: "YHealth" as single compound word
    $fontFamily = "Segoe UI"
    $fontY = New-Object System.Drawing.Font($fontFamily, 124.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $fontHealth = New-Object System.Drawing.Font($fontFamily, 124.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $fontTag = New-Object System.Drawing.Font($fontFamily, 26.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)

    $textStartX = 480.0
    $textY = 140.0

    # Draw "Y" in Vital Emerald
    $brushY = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 16, 185, 129))
    $g.DrawString("Y", $fontY, $brushY, $textStartX, $textY)
    $sizeY = $g.MeasureString("Y", $fontY)
    $brushY.Dispose()

    # Draw "Health" tightly spaced
    $brushHealth = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 38, 25))
    }
    # Tightly join "Health" immediately following "Y"
    $healthX = $textStartX + $sizeY.Width - 28.0
    $g.DrawString("Health", $fontHealth, $brushHealth, $healthX, $textY)
    $brushHealth.Dispose()

    # Draw Tagline
    $brushTag = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 16, 185, 129))
    }
    $g.DrawString("INTELLIGENT VITALITY & WELLNESS", $fontTag, $brushTag, ($textStartX + 6.0), ($textY + 148.0))
    $brushTag.Dispose()

    $fontY.Dispose()
    $fontHealth.Dispose()
    $fontTag.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ----------------------------------------------------------------------------------
# EXECUTION: GENERATE ALL BRAND ASSETS
# ----------------------------------------------------------------------------------

# Ensure directories exist
$brandingDir = "C:\develop\yhealth\assets\branding"
$docsBrandingDir = "C:\develop\yhealth\branding"
$resDir = "C:\develop\yhealth\android\app\src\main\res"

if (-not (Test-Path $brandingDir)) { New-Item -ItemType Directory -Path $brandingDir -Force | Out-Null }
if (-not (Test-Path $docsBrandingDir)) { New-Item -ItemType Directory -Path $docsBrandingDir -Force | Out-Null }

Write-Host "1. Generating Master High-Resolution Branding Assets..."
# Standalone Master Icons
Render-IconSquircle 1024 "$brandingDir\yhealth_symbol_dark_1024.png"
Render-IconSquircle 1024 "$docsBrandingDir\yhealth_symbol_dark_1024.png"
Render-IconRound 1024 "$brandingDir\yhealth_symbol_round_1024.png"
Render-IconRound 1024 "$docsBrandingDir\yhealth_symbol_round_1024.png"

# Play Store 512x512
Render-IconSquircle 512 "$brandingDir\yhealth_playstore_512.png"
Render-IconSquircle 512 "$docsBrandingDir\yhealth_playstore_512.png"

# Complete Logos with Wordmark
Render-WordmarkPackage "$brandingDir\yhealth_logo_wordmark_dark.png" "dark"
Render-WordmarkPackage "$docsBrandingDir\yhealth_logo_wordmark_dark.png" "dark"
Render-WordmarkPackage "$brandingDir\yhealth_logo_wordmark_light.png" "light"
Render-WordmarkPackage "$docsBrandingDir\yhealth_logo_wordmark_light.png" "light"

# Transparent Symbol Assets (1024x1024)
$bmpTrans = New-Object System.Drawing.Bitmap(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$gTrans = [System.Drawing.Graphics]::FromImage($bmpTrans)
$gTrans.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$gTrans.Clear([System.Drawing.Color]::Transparent)
Draw-VitaYSymbol $gTrans 512.0 512.0 1.25 "dark"
$gTrans.Dispose()
$bmpTrans.Save("$brandingDir\yhealth_symbol_transparent.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpTrans.Save("$docsBrandingDir\yhealth_symbol_transparent.png", [System.Drawing.Imaging.ImageFormat]::Png)
$bmpTrans.Dispose()

Write-Host "2. Generating Android Mipmap Launcher Resources..."
$mipmapSpecs = @(
    @{ Name = "mipmap-mdpi";    Squircle = 48;  Round = 48;  Fg = 108 },
    @{ Name = "mipmap-hdpi";    Squircle = 72;  Round = 72;  Fg = 162 },
    @{ Name = "mipmap-xhdpi";   Squircle = 96;  Round = 96;  Fg = 216 },
    @{ Name = "mipmap-xxhdpi";  Squircle = 144; Round = 144; Fg = 324 },
    @{ Name = "mipmap-xxxhdpi"; Squircle = 192; Round = 192; Fg = 432 }
)

foreach ($spec in $mipmapSpecs) {
    $dir = Join-Path $resDir $spec.Name
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    $pathSquircle = Join-Path $dir "ic_launcher.png"
    $pathRound    = Join-Path $dir "ic_launcher_round.png"
    $pathFg       = Join-Path $dir "ic_launcher_foreground.png"

    Write-Host " - Generating for $($spec.Name) (Squircle: $($spec.Squircle)px, Round: $($spec.Round)px, Foreground: $($spec.Fg)px)..."
    Render-IconSquircle $spec.Squircle $pathSquircle
    Render-IconRound $spec.Round $pathRound
    Render-AdaptiveForeground $spec.Fg $pathFg
}

Write-Host "All YHealth brand assets successfully generated!"
