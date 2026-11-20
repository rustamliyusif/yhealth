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

# CONCEPT 3: The Cardio-Kinetic Y
# A unified, elegant letter Y where the central junction flows directly through an ECG vital pulse wave.
function Render-Concept3([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 46, 30),    # #0B2E1E
        [System.Drawing.Color]::FromArgb(255, 6, 25, 16),     # #061910
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Inner subtle rim
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(28, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # 1. Solid Grounding Stem (White)
    $penW = 76.0
    $penStem = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $penW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 520.0, 512.0, 770.0)
    $penStem.Dispose()

    # 2. Continuous Cardio-Kinetic Upper V
    # Points:
    # Top-Left: (280, 260)
    # Approach to center: (420, 480)
    # Dip: (465, 535)
    # Cardiac Spike: (512, 280) - A strong, confident, athletic peak
    # Recovery Dip: (559, 535)
    # Ascent to right: (604, 480)
    # Top-Right: (744, 260)

    $pts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(280.0, 260.0),
        [System.Drawing.PointF]::new(420.0, 480.0),
        [System.Drawing.PointF]::new(465.0, 535.0),
        [System.Drawing.PointF]::new(512.0, 275.0),
        [System.Drawing.PointF]::new(559.0, 535.0),
        [System.Drawing.PointF]::new(604.0, 480.0),
        [System.Drawing.PointF]::new(744.0, 260.0)
    )

    # Draw the main white wave
    $penWave = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $penW)
    $penWave.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWave.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWave.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawLines($penWave, $pts)
    $penWave.Dispose()

    # 3. Accentuate the Right Arm & Pulse Peak with Vibrant Vital Emerald (#10B981)
    # Right stroke segment from peak (512, 275) to (744, 260)
    $penEmerald = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $penW)
    $penEmerald.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penEmerald.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penEmerald.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    
    $ptsEmerald = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(512.0, 275.0),
        [System.Drawing.PointF]::new(559.0, 535.0),
        [System.Drawing.PointF]::new(604.0, 480.0),
        [System.Drawing.PointF]::new(744.0, 260.0)
    )
    $g.DrawLines($penEmerald, $ptsEmerald)
    $penEmerald.Dispose()

    # 4. Central Energy Core (luminous radiant mint dot at the heartbeat apex)
    $apexBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 167, 243, 208)) # Mint glow
    $apexR = 12.0
    $g.FillEllipse($apexBrush, 512.0 - $apexR, 275.0 - $apexR, $apexR * 2.0, $apexR * 2.0)
    $apexBrush.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept3 "C:\develop\yhealth\logo_concepts\concept3.png"
"Rendered Concept 3"
