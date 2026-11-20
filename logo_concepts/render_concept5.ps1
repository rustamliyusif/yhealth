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

# CONCEPT 5: The "Pulse-Wing Y"
# Left arm and stem form a confident, grounding pillar in Crisp White (#FFFFFF).
# Right arm is meticulously crafted as an athletic ECG heartbeat waveform in Radiant Vital Emerald (#10B981) + Mint (#34D399),
# terminating at the top-right in perfect harmony with the left wing!
function Render-Concept5([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # 1. Background: Deep British Racing / Forest Emerald (#0B2A1D -> #061910)
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 44, 29),   # #0B2C1D
        [System.Drawing.Color]::FromArgb(255, 5, 22, 14),    # #05160E
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Inner hairline border for luxury tech polish
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(32, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # 2. Left Spine (Left Arm + Vertical Stem) in Crisp Pure White
    $strokeW = 84.0
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penWhite.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathWhite = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Top-Left to Center Nexus to Bottom
    $pathWhite.AddLine(290.0, 270.0, 512.0, 500.0)
    $pathWhite.AddLine(512.0, 500.0, 512.0, 770.0)
    $g.DrawPath($penWhite, $pathWhite)
    $penWhite.Dispose()
    $pathWhite.Dispose()

    # 3. Right Arm: The Kinetic ECG Pulse Waveform
    # Starting from the nexus (512, 500), it pulses:
    # (512, 500) -> dips to (560, 545) -> spikes up to (625, 280) [Vital Peak] -> dips to (675, 420) -> reaches top-right (734, 270)
    $penEmerald = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $strokeW)
    $penEmerald.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penEmerald.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penEmerald.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pulsePts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(512.0, 500.0),
        [System.Drawing.PointF]::new(565.0, 545.0), # Small cardiac pre-dip
        [System.Drawing.PointF]::new(630.0, 270.0), # Main athletic vital spike
        [System.Drawing.PointF]::new(685.0, 420.0), # S-wave recovery
        [System.Drawing.PointF]::new(734.0, 270.0)  # Ascending terminal (matching top-left height 270)
    )
    $g.DrawLines($penEmerald, $pulsePts)
    $penEmerald.Dispose()

    # 4. A luminous vitality node at the cardiac spike apex
    $apexBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 167, 243, 208)) # Soft Mint
    $apexR = 11.0
    $g.FillEllipse($apexBrush, 630.0 - $apexR, 270.0 - $apexR, $apexR * 2.0, $apexR * 2.0)
    $apexBrush.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept5 "C:\develop\yhealth\logo_concepts\concept5.png"
"Rendered Concept 5"
