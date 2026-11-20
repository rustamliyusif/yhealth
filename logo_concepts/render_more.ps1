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

# --- CONCEPT 2A: The Precision Interlocking Bio-Ribbon Y ---
# Two balanced, perfectly sculpted geometric ribbons forming a clean, athletic Y.
# Left ribbon in Crisp White, Right ribbon in Radiant Vital Emerald (#10B981), overlapping with precision negative-space cut.
function Render-Concept2A([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background: Premium Deep Emerald Squircle
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 12, 44, 30),   # #0C2C1E Deepest Forest
        [System.Drawing.Color]::FromArgb(255, 6, 26, 17),    # #061A11 Midnight Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Subtle inner border for premium glass/app card feel
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(35, 255, 255, 255), 3.0)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # Geometry:
    # Stem is at X = 512, Y from 510 to 780. Width = 100.
    # Left branch goes from (290, 270) to (512, 510).
    # Right branch goes from (734, 270) to (512, 510).
    # But right branch incorporates an energetic ECG impulse step!
    
    $penW = 96.0

    # 1. Left Branch & Central Stem (Solid White, anchored)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $penW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathLeft.AddLine(310.0, 280.0, 512.0, 482.0)
    $pathLeft.AddLine(512.0, 482.0, 512.0, 760.0)
    $g.DrawPath($penLeft, $pathLeft)
    $penLeft.Dispose()
    $pathLeft.Dispose()

    # 2. Right Branch (Radiant Vital Emerald #10B981)
    # Starts at (512, 482), shoots up with a cardiac crest step, then up-right to (714, 280)
    $penRight = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $penW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pathRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Clean angular pulse step: (512, 482) -> (580, 414) -> (600, 470) [pulse dip] -> (640, 310) [pulse peak] -> (714, 280)
    # Or clean geometric direct line with accent:
    $pathRight.AddLine(512.0, 482.0, 714.0, 280.0)
    $g.DrawPath($penRight, $pathRight)
    $penRight.Dispose()
    $pathRight.Dispose()

    # 3. Dynamic pulse wave running along the right wing
    # A sleek mint laser stroke inside the emerald arm
    $pulsePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 167, 243, 208), 24.0) # #A7F3D0
    $pulsePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawLine($pulsePen, 545.0, 449.0, 680.0, 314.0)
    $pulsePen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# --- CONCEPT 2B: The Kinetic Pulse Y (Unified Continuous Vital Wave) ---
# A bold, singular sculpted monogram where the Y's stem and arms form a continuous heartbeat wave.
function Render-Concept2B([string]$outputPath) {
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
        [System.Drawing.Color]::FromArgb(255, 10, 48, 32),
        [System.Drawing.Color]::FromArgb(255, 4, 22, 14),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Draw the Y as a flowing athletic ribbon:
    # Left Arm: Sweeps down gracefully (310, 260) -> (512, 510)
    # Right Arm: Sweeps down gracefully (714, 260) -> (512, 510)
    # Center Stem: Curves down (512, 510) -> (512, 780)
    # BUT with an integrated ECG pulse in the V!
    $penW = 100.0

    # Draw stem first
    $penStem = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $penW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 500.0, 512.0, 770.0)
    $penStem.Dispose()

    # Left wing (White to Emerald gradient)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $penW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penLeft, 305.0, 275.0, 512.0, 512.0)
    $penLeft.Dispose()

    # Right wing
    $penRight = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 46, 213, 115), $penW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 719.0, 275.0, 512.0, 512.0)
    $penRight.Dispose()

    # Central Biometric Heartbeat Core:
    # A vibrant pulsing ECG wave that sweeps across the center junction:
    # from (390, 480) -> (450, 480) -> (485, 540) -> (512, 380) [Heartbeat Spike] -> (540, 530) -> (575, 480) -> (635, 480)
    $pulsePen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 26.0)
    $pulsePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $pts = @(
        New-Object System.Drawing.PointF(370.0, 490.0),
        New-Object System.Drawing.PointF(440.0, 490.0),
        New-Object System.Drawing.PointF(475.0, 535.0),
        New-Object System.Drawing.PointF(512.0, 370.0), # Peak
        New-Object System.Drawing.PointF(550.0, 545.0), # Valley
        New-Object System.Drawing.PointF(585.0, 490.0),
        New-Object System.Drawing.PointF(655.0, 490.0)
    )
    $g.DrawLines($pulsePen, $pts)
    $pulsePen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# --- CONCEPT 2C: The Modern Health-Tech VITA-Y (Geometric Precision Monogram) ---
# Inspired by Apple Health & Swiss precision: A bold, stylized Y where the left arm is a sleek pill,
# the stem is a grounded pillar, and the right arm is a dynamic upward kinetic surge.
# Incorporates clean geometric chamfers and an upward chevron / vital spark in the center.
function Render-Concept2C([string]$outputPath) {
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
        [System.Drawing.Color]::FromArgb(255, 9, 44, 28),    # #092C1C
        [System.Drawing.Color]::FromArgb(255, 4, 20, 13),    # #04140D
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Geometry:
    # 3 Pill segments that assemble into a futuristic, clean health monogram:
    # Left Wing: Capsule from (290, 260) to (470, 480)
    # Right Wing: Capsule from (734, 260) to (554, 480)
    # Stem: Capsule from (512, 540) to (512, 780)
    # In the middle between them (512, 450), a radiant dynamic Pulse Diamond / Chevron (representing vitality & life)
    
    $penW = 105.0

    # Left Pill (White)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $penW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penLeft, 310.0, 275.0, 465.0, 470.0)
    $penLeft.Dispose()

    # Right Pill (Vital Emerald)
    $penRight = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 16, 185, 129), $penW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 714.0, 275.0, 559.0, 470.0)
    $penRight.Dispose()

    # Stem Pill (Gradient Emerald to Mint)
    $penStem = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 52, 211, 153), $penW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 550.0, 512.0, 765.0)
    $penStem.Dispose()

    # Central Vital Spark / Cardio Rhythm Node:
    # A sleek diamond / upward chevron that unifies the nexus
    $nodePath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $nodePath.AddPolygon(@(
        New-Object System.Drawing.PointF(512.0, 395.0), # Top
        New-Object System.Drawing.PointF(545.0, 465.0), # Right
        New-Object System.Drawing.PointF(512.0, 535.0), # Bottom
        New-Object System.Drawing.PointF(479.0, 465.0)  # Left
    ))
    $nodeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($nodeBrush, $nodePath)
    $nodeBrush.Dispose()
    $nodePath.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept2A "C:\develop\yhealth\logo_concepts\concept2a.png"
Render-Concept2B "C:\develop\yhealth\logo_concepts\concept2b.png"
Render-Concept2C "C:\develop\yhealth\logo_concepts\concept2c.png"
"Rendered Concepts 2A, 2B, 2C"
