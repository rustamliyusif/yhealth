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
# MASTER VITA-Y SYMBOL RENDERER (Clean, Scalable, Flawless Vector Geometry)
# ----------------------------------------------------------------------------------
function Draw-VitaYSymbol($g, [float]$cx, [float]$cy, [float]$scale, [string]$theme) {
    $isDark = ($theme -eq "dark")

    # Save state
    $state = $g.Save()
    $g.TranslateTransform($cx, $cy)
    $g.ScaleTransform($scale, $scale)

    # Base design coordinates centered around (0, 0):
    # Total height approx 560px, width approx 520px
    # Stem: X = -56 to +56 (with 14px center gap: Left is -56 to -7, Right is +7 to +56)
    # Stem Y: from -20 to +260.
    # Bottom rounding: radius 24px.
    # Wings: branch out from (-7, -20) and (+7, -20) up to (-220, -250) and (+220, -250).

    $stemW = 48.0   # Width of each side
    $gap = 7.0      # Half-gap (total gap = 14)
    $botY = 260.0
    $juncY = -15.0

    # 1. Left Wing (Pure White in Dark mode, Deep Forest in Light mode)
    $pL = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Outer bottom corner of stem
    $outLX = - ($gap + $stemW)
    $inLX  = - $gap
    $botR  = 24.0

    # Start at inner junction
    # Inner wing curve from inner junction (-gap, juncY) up to inner tip (-165, -280)
    $pL.AddBezier(
        [System.Drawing.PointF]::new($inLX, $juncY),
        [System.Drawing.PointF]::new(-70.0, -80.0),
        [System.Drawing.PointF]::new(-140.0, -180.0),
        [System.Drawing.PointF]::new(-172.0, -265.0)
    )
    # Top-left rounded cap (diameter approx 64px) to outer tip (-232, -235)
    $pL.AddBezier(
        [System.Drawing.PointF]::new(-172.0, -265.0),
        [System.Drawing.PointF]::new(-192.0, -295.0),
        [System.Drawing.PointF]::new(-238.0, -270.0),
        [System.Drawing.PointF]::new(-232.0, -235.0)
    )
    # Outer wing curve from (-232, -235) down to outer stem (outLX, juncY + 30)
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
    # A radiant geometric diamond symbolizing cardiac rhythm and intelligent tracking
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
# 1. RENDER LAUNCHER / STANDALONE APP ICON (1024x1024)
# ----------------------------------------------------------------------------------
function Render-LauncherIcon([string]$outputPath, [string]$theme) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $margin = 44.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.235
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = [System.Drawing.RectangleF]::new($margin, $margin, $w, $w)

    $isDark = ($theme -eq "dark")

    if ($isDark) {
        $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $rect,
            [System.Drawing.Color]::FromArgb(255, 11, 38, 25), # #0B2619 Deep Forest
            [System.Drawing.Color]::FromArgb(255, 4, 16, 11),  # #04100B Obsidian
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        )
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(26, 255, 255, 255), [float]2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    } else {
        $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 246, 250, 248))
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(35, 11, 38, 25), [float]2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    }
    $sqPath.Dispose()

    # Draw the Vita-Y Symbol at center
    Draw-VitaYSymbol $g 512.0 512.0 1.05 $theme

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ----------------------------------------------------------------------------------
# 2. RENDER COMPLETE YHEALTH LOGO WITH WORDMARK (HORIZONTAL 1200x400)
# ----------------------------------------------------------------------------------
function Render-LogoWithWordmark([string]$outputPath, [string]$theme) {
    $width = 1400
    $height = 440
    $bmp = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $isDark = ($theme -eq "dark")

    # Background
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
    Draw-VitaYSymbol $g 220.0 220.0 0.58 $theme

    # Draw Wordmark "YHealth"
    # Find elegant font
    $fontFamily = "Segoe UI"
    $fontY = New-Object System.Drawing.Font($fontFamily, 108.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $fontHealth = New-Object System.Drawing.Font($fontFamily, 108.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $fontTag = New-Object System.Drawing.Font($fontFamily, 22.0, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)

    $textStartX = 410.0
    $textY = 120.0

    # Draw "Y" in Vital Emerald
    $brushY = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 16, 185, 129))
    $g.DrawString("Y", $fontY, $brushY, $textStartX, $textY)
    $sizeY = $g.MeasureString("Y", $fontY)
    $brushY.Dispose()

    # Draw "Health" in White (or Deep Forest in light mode)
    $brushHealth = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 38, 25))
    }
    $healthX = $textStartX + $sizeY.Width - 18.0
    $g.DrawString("Health", $fontHealth, $brushHealth, $healthX, $textY)
    $brushHealth.Dispose()

    # Draw Tagline: "INTELLIGENT VITALITY & WELLNESS"
    $brushTag = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 16, 185, 129))
    }
    $g.DrawString("INTELLIGENT VITALITY & WELLNESS", $fontTag, $brushTag, ($textStartX + 6.0), ($textY + 130.0))
    $brushTag.Dispose()

    $fontY.Dispose()
    $fontHealth.Dispose()
    $fontTag.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-LauncherIcon "C:\develop\yhealth\logo_concepts\yhealth_icon_dark.png" "dark"
Render-LauncherIcon "C:\develop\yhealth\logo_concepts\yhealth_icon_light.png" "light"
Render-LogoWithWordmark "C:\develop\yhealth\logo_concepts\yhealth_wordmark_dark.png" "dark"
Render-LogoWithWordmark "C:\develop\yhealth\logo_concepts\yhealth_wordmark_light.png" "light"
"Rendered Final Identity Concepts"
