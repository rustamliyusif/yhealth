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

# CONCEPT 6: The "Helix-Y" / "Vital Bloom"
# Two elegant, mathematically symmetrical ribbons that sweep downward from the upper left & right,
# meeting at the center stem and overlapping with exquisite precision.
# Left ribbon in Crisp White (purity, medical trust)
# Right ribbon in Vibrant Vital Emerald #10B981 -> Mint #34D399 (activity, cardio energy, life)
# Symmetrical, timeless, recognizable at 16x16.
function Render-Concept6([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Background: Deep Luxury Forest Green #0B291D to #05160E
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 42, 28),   # #0B2A1C
        [System.Drawing.Color]::FromArgb(255, 4, 18, 12),    # #04120C
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Hairline inner border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(28, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # Geometry:
    # Ribbon width: 90px
    # Left Arm: from (300, 260) curving down to (470, 520) then vertical down to (470, 770)
    # Right Arm: from (724, 260) curving down to (554, 520) then vertical down to (554, 770)
    # Notice: Two parallel pillars in the stem, with a gap between them or meeting at (512, 510)!
    # Let's test them meeting seamlessly at the center stem:
    
    $strokeW = 92.0

    # Left Ribbon (White):
    # Starts at (290, 260), sweeps smoothly via bezier to (512, 510), then straight down to (512, 775)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(300.0, 265.0),
        [System.Drawing.PointF]::new(380.0, 360.0),
        [System.Drawing.PointF]::new(480.0, 460.0),
        [System.Drawing.PointF]::new(512.0, 515.0)
    )
    $pathLeft.AddLine(512.0, 515.0, 512.0, 775.0)
    $g.DrawPath($penLeft, $pathLeft)
    $penLeft.Dispose()
    $pathLeft.Dispose()

    # Right Ribbon (Vital Emerald #10B981 to Mint #34D399 Gradient):
    # Starts at (724, 265), sweeps smoothly via bezier to (512, 515), then down to (512, 775)
    $rectRight = New-Object System.Drawing.RectangleF(500.0, 250.0, 250.0, 540.0)
    $brushRight = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectRight,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # #34D399 Vibrant Mint
        [System.Drawing.Color]::FromArgb(255, 5, 150, 105),  # #059669 Rich Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $penRight = New-Object System.Drawing.Pen($brushRight, $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(724.0, 265.0),
        [System.Drawing.PointF]::new(644.0, 360.0),
        [System.Drawing.PointF]::new(544.0, 460.0),
        [System.Drawing.PointF]::new(512.0, 515.0)
    )
    $pathRight.AddLine(512.0, 515.0, 512.0, 775.0)
    $g.DrawPath($penRight, $pathRight)
    $brushRight.Dispose()
    $penRight.Dispose()
    $pathRight.Dispose()

    # 3. The Vitality Spark / Pulse Nexus in the Center:
    # Where the two ribbons unite at (512, 515), a pristine negative space / cut-through or biometric pulse dot:
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 42, 28))
    $dotR = 18.0
    $g.FillEllipse($dotBrush, 512.0 - $dotR, 515.0 - $dotR, $dotR * 2.0, $dotR * 2.0)
    $dotBrush.Dispose()

    $innerDot = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 110, 245, 180)) # Mint core
    $g.FillEllipse($innerDot, 512.0 - 9.0, 515.0 - 9.0, 18.0, 18.0)
    $innerDot.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept6 "C:\develop\yhealth\logo_concepts\concept6.png"
"Rendered Concept 6"
