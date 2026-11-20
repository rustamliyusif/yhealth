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

# --- CONCEPT 7A: The "Bio-Track Y" (Dual-Channel Kinetic Ribbon) ---
# Inspired by athletic running tracks & biometric signals:
# Two sleek parallel channels form the stem, then branch into the left and right wings.
# Modern, architectural, looks like an elite Scandinavian health-tech brand.
function Render-Concept7A([string]$outputPath) {
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
        [System.Drawing.Color]::FromArgb(255, 10, 40, 27),   # Deep Forest
        [System.Drawing.Color]::FromArgb(255, 4, 18, 12),    # Midnight Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Hairline border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # Geometry:
    # Stem: X = 465 (Left white track), X = 559 (Right emerald track)
    # Both tracks have width = 64px, gap = 30px between them!
    # Left track goes from (290, 270) down-right to (465, 490) then straight down to (465, 765)
    # Right track goes from (734, 270) down-left to (559, 490) then straight down to (559, 765)
    # Between them in the center, a luminous vital pulse heartbeat chevron / bridge connects them!
    
    $trackW = 72.0

    # Left Track (Pure White)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $trackW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(305.0, 270.0),
        [System.Drawing.PointF]::new(370.0, 360.0),
        [System.Drawing.PointF]::new(450.0, 450.0),
        [System.Drawing.PointF]::new(465.0, 510.0)
    )
    $pathLeft.AddLine(465.0, 510.0, 465.0, 765.0)
    $g.DrawPath($penLeft, $pathLeft)
    $penLeft.Dispose()
    $pathLeft.Dispose()

    # Right Track (Vital Emerald #10B981)
    $penRight = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $trackW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(719.0, 270.0),
        [System.Drawing.PointF]::new(654.0, 360.0),
        [System.Drawing.PointF]::new(574.0, 450.0),
        [System.Drawing.PointF]::new(559.0, 510.0)
    )
    $pathRight.AddLine(559.0, 510.0, 559.0, 765.0)
    $g.DrawPath($penRight, $pathRight)
    $penRight.Dispose()
    $pathRight.Dispose()

    # The Vitality Bridge: An energetic horizontal ECG pulse that leaps between the two tracks!
    # Connecting Left Track (465, 590) to Right Track (559, 590) with an acute upward spike (512, 530)
    $bridgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 52, 211, 153), 26.0) # #34D399 Mint
    $bridgePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $bridgePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $bridgePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $bridgePts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(465.0, 600.0),
        [System.Drawing.PointF]::new(490.0, 600.0),
        [System.Drawing.PointF]::new(512.0, 530.0), # Heartbeat spike between the pillars
        [System.Drawing.PointF]::new(534.0, 640.0), # Quick rebound dip
        [System.Drawing.PointF]::new(559.0, 600.0)
    )
    $g.DrawLines($bridgePen, $bridgePts)
    $bridgePen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# --- CONCEPT 7B: The "Aero-Vital Y" (Sculpted Dynamic Monogram) ---
# A solid, sculptural mark where the Y is formed by an athletic upward chevron wing on the left,
# a confident grounding stem, and a kinetic pulse wing on the right with a clean golden-ratio negative slit.
function Render-Concept7B([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background: Ultra-luxurious Deep Emerald
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 9, 38, 25),    # #092619
        [System.Drawing.Color]::FromArgb(255, 3, 16, 11),    # #03100B
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Hairline border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(30, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # Geometry:
    # 2 Sculpted Shapes forming the Y:
    # Shape 1 (Left Wing + Stem): A solid, sweeping curve from (280, 260) to (512, 500) to (512, 780).
    # Shape 2 (Right Wing): A bold diagonal from (744, 260) to (545, 470).
    # But between Shape 1 and Shape 2, a clean 32px diagonal air-gap creates an athletic negative space slash!
    # And at the top-right wing, a secondary pulse accent in luminous mint (#34D399) creates vitality and depth.
    
    $strokeW = 100.0

    # Shape 1: Left Wing + Stem (Crisp Pure White)
    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penWhite.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathWhite = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathWhite.AddLine(290.0, 265.0, 512.0, 487.0)
    $pathWhite.AddLine(512.0, 487.0, 512.0, 775.0)
    $g.DrawPath($penWhite, $pathWhite)
    $penWhite.Dispose()
    $pathWhite.Dispose()

    # Shape 2: Right Wing (Vibrant Vital Emerald #10B981)
    # Starts at (555, 444), ends at (734, 265). Gap to center nexus is 32px.
    $penEmerald = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $strokeW)
    $penEmerald.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penEmerald.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penEmerald, 555.0, 444.0, 734.0, 265.0)
    $penEmerald.Dispose()

    # Vitality Pulse Accent (Mint #34D399 floating beside the right wing):
    # A parallel secondary pulse stroke, creating the sensation of forward speed / cardio rhythm:
    $penAccent = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 52, 211, 153), 28.0)
    $penAccent.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penAccent.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    # Offset by 60px perpendicular up-right:
    # Parallel from (620, 230) to (760, 230) or parallel diagonal
    $g.DrawLine($penAccent, 630.0, 310.0, 710.0, 230.0)
    $penAccent.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept7A "C:\develop\yhealth\logo_concepts\concept7a.png"
Render-Concept7B "C:\develop\yhealth\logo_concepts\concept7b.png"
"Rendered Concepts 7A and 7B"
