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

function Init-DarkCanvas() {
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

    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 10, 36, 24), # Luxury Deep Forest Emerald
        [System.Drawing.Color]::FromArgb(255, 4, 16, 11),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()

    $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(28, 255, 255, 255), [float]2.0)
    $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
    $g.DrawPath($rimPen, $innerPath)
    $rimPen.Dispose()
    $innerPath.Dispose()
    $sqPath.Dispose()

    return @{ Bitmap = $bmp; Graphics = $g }
}

# -------------------------------------------------------------------------
# REFINEMENT F1: "The Sculpted Kinetic Wings Y" (Precision Bezier)
# Perfect geometric curves with a straight, grounded vertical stem and an elegant
# negative-space channel down the center.
# -------------------------------------------------------------------------
function Render-F1([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $stemW = 54.0   # Width of each half of the stem
    $gap = 10.0     # Precision central seam
    $stemBot = 770.0
    $junctionY = 480.0
    $wingTopY = 240.0
    $wingLeftX = 280.0
    $wingRightX = 744.0

    # 1. Left Wing (Pure White)
    $pathL = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Start at top-left outer tip
    $pathL.AddBezier(
        [System.Drawing.PointF]::new($wingLeftX, $wingTopY),
        [System.Drawing.PointF]::new(360.0, 370.0),
        [System.Drawing.PointF]::new(512.0 - $gap - $stemW, $junctionY),
        [System.Drawing.PointF]::new(512.0 - $gap - $stemW, $stemBot - 28.0)
    )
    # Bottom round cap
    $pathL.AddArc(512.0 - $gap - $stemW, $stemBot - 56.0, $stemW, 56.0, 90, 90)
    # Inside vertical edge
    $pathL.AddLine(512.0 - $gap, $stemBot - 28.0, 512.0 - $gap, $junctionY)
    # Inner wing curve back to top-left
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(512.0 - $gap, $junctionY),
        [System.Drawing.PointF]::new(440.0, 390.0),
        [System.Drawing.PointF]::new(370.0, 300.0),
        [System.Drawing.PointF]::new(350.0, $wingTopY - 10.0)
    )
    # Top-left rounded cap
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(350.0, $wingTopY - 10.0),
        [System.Drawing.PointF]::new(320.0, $wingTopY - 25.0),
        [System.Drawing.PointF]::new(280.0, $wingTopY + 10.0),
        [System.Drawing.PointF]::new($wingLeftX, $wingTopY)
    )
    $pathL.CloseFigure()

    $brushL = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushL, $pathL)
    $brushL.Dispose()
    $pathL.Dispose()

    # 2. Right Wing (Vital Emerald to Mint Gradient)
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathR.AddBezier(
        [System.Drawing.PointF]::new($wingRightX, $wingTopY),
        [System.Drawing.PointF]::new(664.0, 370.0),
        [System.Drawing.PointF]::new(512.0 + $gap + $stemW, $junctionY),
        [System.Drawing.PointF]::new(512.0 + $gap + $stemW, $stemBot - 28.0)
    )
    $pathR.AddArc(512.0 + $gap, $stemBot - 56.0, $stemW, 56.0, 0, 90)
    $pathR.AddLine(512.0 + $gap, $stemBot - 28.0, 512.0 + $gap, $junctionY)
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(512.0 + $gap, $junctionY),
        [System.Drawing.PointF]::new(584.0, 390.0),
        [System.Drawing.PointF]::new(654.0, 300.0),
        [System.Drawing.PointF]::new(674.0, $wingTopY - 10.0)
    )
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(674.0, $wingTopY - 10.0),
        [System.Drawing.PointF]::new(704.0, $wingTopY - 25.0),
        [System.Drawing.PointF]::new(744.0, $wingTopY + 10.0),
        [System.Drawing.PointF]::new($wingRightX, $wingTopY)
    )
    $pathR.CloseFigure()

    $rectR = [System.Drawing.RectangleF]::new(512.0, [float]($wingTopY - 30.0), 260.0, 600.0)
    $brushR = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectR,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint #34D399
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald #10B981
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPath($brushR, $pathR)
    $brushR.Dispose()
    $pathR.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# REFINEMENT F2: "The Vitality Nexus Monogram"
# Solid unified stem (White + Emerald gradient)
# + Two soaring athletic wings
# + Precision Diamond Cardio-Core in the V!
# -------------------------------------------------------------------------
function Render-F2([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 104.0
    $cx = 512.0
    $cy = 475.0
    $botY = 775.0

    # 1. Stem (Pure White)
    $penStem = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, $cx, $cy, $cx, $botY)
    $penStem.Dispose()

    # 2. Left Wing (Pure White) - graceful athletic curve
    $pL = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pL.AddBezier(
        [System.Drawing.PointF]::new(295.0, 255.0),
        [System.Drawing.PointF]::new(365.0, 365.0),
        [System.Drawing.PointF]::new(455.0, 445.0),
        [System.Drawing.PointF]::new($cx, $cy)
    )
    $penL = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penL.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penL.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penL, $pL)
    $penL.Dispose()
    $pL.Dispose()

    # 3. Right Wing (Vital Emerald to Mint Gradient)
    # Branching from nexus to top-right with an athletic forward sweep
    $pR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pR.AddBezier(
        [System.Drawing.PointF]::new($cx + 20.0, $cy - 20.0),
        [System.Drawing.PointF]::new(565.0, 410.0),
        [System.Drawing.PointF]::new(655.0, 335.0),
        [System.Drawing.PointF]::new(729.0, 240.0)
    )
    $rectGrad = New-Object System.Drawing.RectangleF(510.0, 220.0, 240.0, 280.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penR = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penR.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penR, $pR)
    $penR.Dispose()
    $brushGrad.Dispose()
    $pR.Dispose()

    # 4. Central Cardio Diamond Node:
    # A faceted diamond at the nexus connecting the white spine and the emerald wing
    $diaSize = 34.0
    $dPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $dPath.AddPolygon([System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx, $cy - $diaSize),
        [System.Drawing.PointF]::new($cx + $diaSize, $cy),
        [System.Drawing.PointF]::new($cx, $cy + $diaSize),
        [System.Drawing.PointF]::new($cx - $diaSize, $cy)
    ))
    $dRect = [System.Drawing.RectangleF]::new([float]($cx - $diaSize), [float]($cy - $diaSize), [float]($diaSize * 2.0), [float]($diaSize * 2.0))
    $dBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $dRect,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($dBrush, $dPath)
    $dBrush.Dispose()
    $dPath.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# REFINEMENT F3: "The Heartbeat Chevron Y"
# What if the top arms of the Y are an inverted chevron / pulse wave,
# and the stem is solid?
# Left Arm: Crisp White
# Right Arm: Vital Emerald
# Stem: Crisp White
# Nexus: Precision athletic notch
# -------------------------------------------------------------------------
function Render-F3([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 96.0

    # Spine (Left Arm + Stem): Pure White
    # Starts at (305, 250), descends to junction (512, 470), drops straight down to (512, 775)
    $pathSpine = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathSpine.AddLine(310.0, 250.0, 512.0, 470.0)
    $pathSpine.AddLine(512.0, 470.0, 512.0, 775.0)

    $penSpine = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penSpine.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penSpine, $pathSpine)
    $penSpine.Dispose()
    $pathSpine.Dispose()

    # Right Arm: Vital Emerald Gradient
    # Starts from (550, 430) to give a 32px negative-space notch, ending at (714, 250)
    $rectGrad = New-Object System.Drawing.RectangleF(530.0, 230.0, 200.0, 230.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, 552.0, 428.0, 714.0, 250.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    # Pulse accent: A clean 16px radiant mint heartbeat pulse line inside the stem!
    # Running from (512, 540) to (512, 700)
    $pulsePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 16, 185, 129), [float]18.0)
    $pulsePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($pulsePen, 512.0, 540.0, 512.0, 710.0)
    $pulsePen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-F1 "C:\develop\yhealth\logo_concepts\refine_f1.png"
Render-F2 "C:\develop\yhealth\logo_concepts\refine_f2.png"
Render-F3 "C:\develop\yhealth\logo_concepts\refine_f3.png"
"Rendered Refinements F1, F2, F3"
