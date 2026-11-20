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

# CONCEPT 4: The Precision Biometric Y (High-Tech Modular Monogram)
# 3 meticulously aligned geometric strokes with subtle negative space gaps:
# Left arm (Pure White, trust & medical foundation)
# Stem (Pure White, stability)
# Right arm (Vital Emerald, forward momentum, dynamic surge)
# Plus a sleek cardio wave accent line that ties the entire monogram together.
function Render-Concept4([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Background: Deep Forest Emerald Gradient with subtle luminescence
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 13, 51, 34),   # #0D3322
        [System.Drawing.Color]::FromArgb(255, 6, 26, 17),    # #061A11
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Subtle inner border for glassmorphic depth
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # 2. Geometry:
    # A continuous Left Spine: From (310, 270) down to (512, 490) then down to (512, 770)
    # Right Wing: From (714, 270) down to (536, 466) with a precision 24px gap before the junction!
    # AND on the right wing, an athletic heartbeat pulse notch / facet!

    $strokeW = 92.0

    # Draw Left Arm & Stem as a seamless unified spine (Crisp White)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathSpine = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathSpine.AddLine(310.0, 270.0, 512.0, 485.0)
    $pathSpine.AddLine(512.0, 485.0, 512.0, 770.0)
    $g.DrawPath($penLeft, $pathSpine)
    $penLeft.Dispose()
    $pathSpine.Dispose()

    # Draw Right Wing in Vital Emerald (#10B981)
    # With a precision separation gap at the junction (536, 462) to (714, 270)
    $penRight = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 545.0, 450.0, 714.0, 270.0)
    $penRight.Dispose()

    # Now, add the "Vitality Signal":
    # A luminous neon mint ECG heartbeat line that runs INSIDE the right wing and leaps across the gap:
    # From (480, 520) on the white spine, cutting dynamically across into the emerald wing:
    $penSignal = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 167, 243, 208), 20.0) # #A7F3D0
    $penSignal.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSignal.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSignal.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $signalPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(440.0, 410.0), # On the white left arm
        [System.Drawing.PointF]::new(480.0, 450.0),
        [System.Drawing.PointF]::new(512.0, 390.0), # Sharp pulse peak
        [System.Drawing.PointF]::new(550.0, 470.0), # Valley
        [System.Drawing.PointF]::new(660.0, 350.0)  # Ascending up the emerald arm
    )
    $g.DrawLines($penSignal, $signalPts)
    $penSignal.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept4 "C:\develop\yhealth\logo_concepts\concept4.png"
"Rendered Concept 4"
