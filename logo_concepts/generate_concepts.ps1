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

# --- CONCEPT 1: The Bio-Kinetic Y (Dual-Ribbon Pulse & Vital Spine) ---
# Deep forest green background, crisp white left spine + radiant emerald kinetic pulse wing
function Render-Concept1([string]$outputPath, [int]$size, [bool]$isDarkBg) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $s = $size / 1024.0

    if ($isDarkBg) {
        # Luxurious Deep Forest Green squircle
        $margin = 40.0 * $s
        $w = $size - (2.0 * $margin)
        $radius = $w * 0.24
        $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
        
        $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
        $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $rect,
            [System.Drawing.Color]::FromArgb(255, 14, 58, 38),   # #0E3A26 Deep Forest Green
            [System.Drawing.Color]::FromArgb(255, 7, 33, 21),    # #072115 Night Emerald
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        )
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()
        $sqPath.Dispose()
    }

    # Center is at (512, 512) on 1024 canvas
    $cx = $size / 2.0
    $cy = $size / 2.0

    # Stroke 1: Left Wing & Stem (The Spine)
    # Starts at (290, 260), sweeps smoothly down-right to (480, 520), then straight down to (480, 770)
    $penWidth = 92.0 * $s
    $stroke1Color = if ($isDarkBg) { [System.Drawing.Color]::White } else { [System.Drawing.Color]::FromArgb(255, 11, 46, 30) }
    $pen1 = New-Object System.Drawing.Pen($stroke1Color, $penWidth)
    $pen1.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen1.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen1.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Smooth cubic bezier from top-left to stem
    $p1_start = New-Object System.Drawing.PointF(($cx - 200.0 * $s), ($cy - 240.0 * $s))
    $p1_c1 = New-Object System.Drawing.PointF(($cx - 160.0 * $s), ($cy - 60.0 * $s))
    $p1_c2 = New-Object System.Drawing.PointF(($cx - 30.0 * $s), ($cy + 20.0 * $s))
    $p1_junction = New-Object System.Drawing.PointF(($cx - 30.0 * $s), ($cy + 60.0 * $s))
    $p1_bottom = New-Object System.Drawing.PointF(($cx - 30.0 * $s), ($cy + 250.0 * $s))

    $path1.AddBezier($p1_start, $p1_c1, $p1_c2, $p1_junction)
    $path1.AddLine($p1_junction, $p1_bottom)
    $g.DrawPath($pen1, $path1)
    $pen1.Dispose()
    $path1.Dispose()

    # Stroke 2: The Kinetic Pulse Wing (Right arm)
    # Starts from (480, 520), dips subtly into a cardiac valley (520, 560), surges UP into a high athletic peak (610, 310),
    # then sweeps gracefully to the top-right terminal (735, 260)
    $pulseColor = [System.Drawing.Color]::FromArgb(255, 46, 204, 113) # Vibrant Vital Emerald #2ECC71
    $pen2 = New-Object System.Drawing.Pen($pulseColor, $penWidth)
    $pen2.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen2.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pen2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
    $p2_start = New-Object System.Drawing.PointF(($cx - 25.0 * $s), ($cy + 60.0 * $s))
    $p2_dip = New-Object System.Drawing.PointF(($cx + 40.0 * $s), ($cy + 100.0 * $s))
    $p2_peak = New-Object System.Drawing.PointF(($cx + 110.0 * $s), ($cy - 120.0 * $s))
    $p2_end = New-Object System.Drawing.PointF(($cx + 205.0 * $s), ($cy - 240.0 * $s))

    $path2.AddLine($p2_start, $p2_dip)
    $path2.AddLine($p2_dip, $p2_peak)
    $path2.AddLine($p2_peak, $p2_end)
    $g.DrawPath($pen2, $path2)
    $pen2.Dispose()
    $path2.Dispose()

    # Vitality Energy Sparkle (at apex of pulse peak)
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 110, 245, 175))
    $dotR = 12.0 * $s
    $g.FillEllipse($dotBrush, ($cx + 110.0 * $s - $dotR), ($cy - 120.0 * $s - $dotR), ($dotR * 2), ($dotR * 2))
    $dotBrush.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept1 "C:\develop\yhealth\logo_concepts\concept1_dark.png" 1024 $true
Render-Concept1 "C:\develop\yhealth\logo_concepts\concept1_light.png" 1024 $false
"Rendered Concept 1"
