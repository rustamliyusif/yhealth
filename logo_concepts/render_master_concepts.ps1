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

function Init-Canvas([string]$bgType) {
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
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)

    if ($bgType -eq "dark") {
        # Premium Deep Forest Emerald
        $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $rect,
            [System.Drawing.Color]::FromArgb(255, 10, 36, 24), # #0A2418 Deep Forest
            [System.Drawing.Color]::FromArgb(255, 4, 16, 11),  # #04100B Obsidian Green
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        )
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        # Subtle inner ambient rim
        $rimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(24, 255, 255, 255), 2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2) ($margin + 2) ($w - 4) ($w - 4) ($radius - 2)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    } else {
        # Crisp Modern Light Background
        $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 248, 250, 249))
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        $rimPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(25, 10, 36, 24), 2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2) ($margin + 2) ($w - 4) ($w - 4) ($radius - 2)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    }
    $sqPath.Dispose()

    return @{ Bitmap = $bmp; Graphics = $g }
}

# -------------------------------------------------------------
# CONCEPT 10: "The Synchronized Bi-Track Y"
# Two energetic, rounded parallel tracks that form a sleek athletic Y.
# Left track (White): starts top-left (340, 250), curves into stem (460, 770).
# Right track (Emerald): starts top-right (684, 250), curves into stem (564, 770).
# In the upper stem, they run parallel with a 24px precision gap.
# The right wing is slightly raised or surges forward, evoking cardio acceleration.
# -------------------------------------------------------------
function Render-Concept10([string]$outputPath) {
    $canvas = Init-Canvas "dark"
    $g = $canvas.Graphics
    $bmp = $canvas.Bitmap

    $strokeW = 88.0

    # Left Track: Pure White
    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(315.0, 250.0),
        [System.Drawing.PointF]::new(370.0, 360.0),
        [System.Drawing.PointF]::new(455.0, 460.0),
        [System.Drawing.PointF]::new(455.0, 560.0)
    )
    $pathLeft.AddLine(455.0, 560.0, 455.0, 770.0)

    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penLeft, $pathLeft)
    $penLeft.Dispose()
    $pathLeft.Dispose()

    # Right Track: Vital Emerald (#10B981) to Mint (#34D399)
    $pathRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(709.0, 250.0),
        [System.Drawing.PointF]::new(654.0, 360.0),
        [System.Drawing.PointF]::new(569.0, 460.0),
        [System.Drawing.PointF]::new(569.0, 560.0)
    )
    $pathRight.AddLine(569.0, 560.0, 569.0, 770.0)

    $rectGrad = New-Object System.Drawing.RectangleF(500.0, 240.0, 250.0, 550.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # #34D399 Mint top
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # #10B981 Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $penRight = New-Object System.Drawing.Pen($brushGrad, $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penRight, $pathRight)
    $penRight.Dispose()
    $brushGrad.Dispose()
    $pathRight.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------
# CONCEPT 11: "The Intersecting Vitality Monogram"
# A continuous dynamic athletic ribbon:
# Main stem and left arm is a solid unified white branch.
# The right arm is a vital emerald blade that sweeps gracefully into the nexus
# with an elegant overlap shadow or cut, and has an energetic 45-degree cardio peak at its top tip!
# -------------------------------------------------------------
function Render-Concept11([string]$outputPath) {
    $canvas = Init-Canvas "dark"
    $g = $canvas.Graphics
    $bmp = $canvas.Bitmap

    $strokeW = 96.0

    # 1. Main Spine (Left Arm + Stem in crisp white)
    $penSpine = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penSpine.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $ptsSpine = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(310.0, 260.0),
        [System.Drawing.PointF]::new(512.0, 480.0),
        [System.Drawing.PointF]::new(512.0, 770.0)
    )
    $g.DrawLines($penSpine, $ptsSpine)
    $penSpine.Dispose()

    # 2. Right Arm (Vital Emerald)
    # Originates from the nexus (512, 480) and extends to (714, 260)
    # With a precision 26px negative-space mask around the intersection for high-tech architectural depth!
    # Negative space mask:
    $penMask = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 10, 36, 24), $strokeW + 28.0)
    $penMask.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penMask.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penMask, 512.0, 480.0, 560.0, 428.0)
    $penMask.Dispose()

    # Redraw spine top to keep crisp
    $penSpine2 = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penSpine2.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine2.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine2.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawLines($penSpine2, $ptsSpine)
    $penSpine2.Dispose()

    # Now the Emerald right arm:
    $rectGrad = New-Object System.Drawing.RectangleF(520.0, 240.0, 220.0, 260.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint top
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald base
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = New-Object System.Drawing.Pen($brushGrad, $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 542.0, 447.0, 714.0, 260.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    # 3. Add a pulse ring or vital node at the nexus:
    # A vibrant glowing diamond / pulse bead at the intersection
    $nodeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 52, 211, 153))
    $diamond = New-Object System.Drawing.Drawing2D.GraphicsPath
    $dSize = 22.0
    $cx = 512.0
    $cy = 480.0
    $diamond.AddPolygon([System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx, $cy - $dSize),
        [System.Drawing.PointF]::new($cx + $dSize, $cy),
        [System.Drawing.PointF]::new($cx, $cy + $dSize),
        [System.Drawing.PointF]::new($cx - $dSize, $cy)
    ))
    $g.FillPath($nodeBrush, $diamond)
    $nodeBrush.Dispose()
    $diamond.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------
# CONCEPT 12: "The Cardio-Wave Y (The Heartbeat Monogram)"
# Here the letter Y IS the heartbeat wave in 3D perspective / athletic flight:
# Left wing descends diagonally.
# At the center, it produces an upward ECG pulse spike!
# Then drops into the stem, and the right arm leaps up!
# Let's engineer this with continuous smooth geometry.
# -------------------------------------------------------------
function Render-Concept12([string]$outputPath) {
    $canvas = Init-Canvas "dark"
    $g = $canvas.Graphics
    $bmp = $canvas.Bitmap

    # Geometric Ribbon:
    # Left Arm: (300, 260) to (470, 450)
    # Heartbeat Pulse: (470, 450) -> (512, 360) -> (554, 450)
    # Stem: from (512, 460) to (512, 770)
    # Right Arm: from (554, 450) to (724, 260)
    $strokeW = 86.0

    # 1. White Left Track & Stem
    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathLeft.AddLine(305.0, 260.0, 465.0, 440.0)
    $pathLeft.AddLine(465.0, 440.0, 512.0, 490.0)
    $pathLeft.AddLine(512.0, 490.0, 512.0, 770.0)

    $penWhite = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penWhite.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penWhite, $pathLeft)
    $penWhite.Dispose()
    $pathLeft.Dispose()

    # 2. Emerald Right Arm
    $rectGrad = New-Object System.Drawing.RectangleF(510.0, 240.0, 230.0, 260.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = New-Object System.Drawing.Pen($brushGrad, $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 545.0, 453.0, 719.0, 260.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    # 3. Dynamic Cardio Peak:
    # A glowing electric pulse surge bridging the two arms:
    $pulsePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 52, 211, 153), 26.0)
    $pulsePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    # Pulse waveform traversing across the arms:
    # (430, 400) -> (480, 400) -> (512, 330) -> (544, 400) -> (594, 400)
    $pulsePts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(400.0, 440.0),
        [System.Drawing.PointF]::new(470.0, 440.0),
        [System.Drawing.PointF]::new(512.0, 340.0),
        [System.Drawing.PointF]::new(554.0, 440.0),
        [System.Drawing.PointF]::new(624.0, 440.0)
    )
    $g.DrawLines($pulsePen, $pulsePts)
    $pulsePen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------
# CONCEPT 13: "The Bio-Dynamic Y (Aspiration & Vitality Wings)"
# Look at the human figure in motion / celebration:
# Two bold, sculpted athletic leaves/wings that merge into a single powerful trunk.
# Modeled using smooth parametric Bezier curves.
# -------------------------------------------------------------
function Render-Concept13([string]$outputPath) {
    $canvas = Init-Canvas "dark"
    $g = $canvas.Graphics
    $bmp = $canvas.Bitmap

    # Clean geometric construction:
    # Left wing (White): A fluid athletic curve from top left down to center stem.
    # Right wing (Emerald): A symmetric or slightly elevated athletic curve.
    # United at the stem into a single solid trunk.
    # Between the arms in the V sits an athletic cardio teardrop/gem.

    # Left Branch (Pure White)
    $pLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pLeft.AddBezier(
        [System.Drawing.PointF]::new(290.0, 250.0),
        [System.Drawing.PointF]::new(360.0, 390.0),
        [System.Drawing.PointF]::new(480.0, 490.0),
        [System.Drawing.PointF]::new(480.0, 770.0)
    )
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 92.0)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penLeft, $pLeft)
    $penLeft.Dispose()
    $pLeft.Dispose()

    # Right Branch (Emerald Gradient)
    $pRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pRight.AddBezier(
        [System.Drawing.PointF]::new(734.0, 250.0),
        [System.Drawing.PointF]::new(664.0, 390.0),
        [System.Drawing.PointF]::new(544.0, 490.0),
        [System.Drawing.PointF]::new(544.0, 770.0)
    )
    $rectGrad = New-Object System.Drawing.RectangleF(500.0, 230.0, 260.0, 560.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $penRight = New-Object System.Drawing.Pen($brushGrad, 92.0)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penRight, $pRight)
    $penRight.Dispose()
    $brushGrad.Dispose()
    $pRight.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept10 "C:\develop\yhealth\logo_concepts\concept10.png"
Render-Concept11 "C:\develop\yhealth\logo_concepts\concept11.png"
Render-Concept12 "C:\develop\yhealth\logo_concepts\concept12.png"
Render-Concept13 "C:\develop\yhealth\logo_concepts\concept13.png"
"Rendered Concepts 10, 11, 12, 13"
