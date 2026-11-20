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
        [System.Drawing.Color]::FromArgb(255, 10, 36, 24), # Deep Forest Emerald
        [System.Drawing.Color]::FromArgb(255, 4, 16, 11),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()

    $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(24, 255, 255, 255), [float]2.0)
    $innerPath = Create-RoundedRectanglePath ($margin + 2) ($margin + 2) ($w - 4) ($w - 4) ($radius - 2)
    $g.DrawPath($rimPen, $innerPath)
    $rimPen.Dispose()
    $innerPath.Dispose()
    $sqPath.Dispose()

    return @{ Bitmap = $bmp; Graphics = $g }
}

# -------------------------------------------------------------------------
# VARIANT A: "The Vitality Triad (Precision Geometric Monogram)"
# Three rounded power-capsules converging at a central nexus:
# - Stem (Bottom): Vertical capsule in crisp White (Endurance & Grounding)
# - Left Arm: Angled capsule in White (Stability & Health)
# - Right Arm: Angled capsule in Radiant Vital Emerald to Mint (Cardio Surge & Life)
# Between the arms at the center, a 28px air-gap with an iconic diamond nexus!
# -------------------------------------------------------------------------
function Render-VariantA([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $cx = 512.0
    $cy = 480.0
    $gap = 26.0 # Distance from center
    $len = 260.0
    $strokeW = 96.0

    # 1. Stem (Downwards: 90 deg)
    $penStem = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, $cx, $cy + $gap + ($strokeW / 2.0), $cx, $cy + $gap + $len)
    $penStem.Dispose()

    # 2. Left Arm (Angle: 215 deg from down, or 135 deg / up-left)
    # Standard Y angle: 35 degrees from vertical = left arm at (-sin 35, -cos 35)
    $radLeft = 35.0 * [Math]::PI / 180.0
    $lx1 = $cx - ($gap + ($strokeW / 2.0)) * [Math]::Sin($radLeft)
    $ly1 = $cy - ($gap + ($strokeW / 2.0)) * [Math]::Cos($radLeft)
    $lx2 = $cx - ($gap + $len) * [Math]::Sin($radLeft)
    $ly2 = $cy - ($gap + $len) * [Math]::Cos($radLeft)

    $penLeft = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penLeft, [float]$lx1, [float]$ly1, [float]$lx2, [float]$ly2)
    $penLeft.Dispose()

    # 3. Right Arm (Angle: 35 degrees up-right, Vital Emerald Gradient)
    $rx1 = $cx + ($gap + ($strokeW / 2.0)) * [Math]::Sin($radLeft)
    $ry1 = $cy - ($gap + ($strokeW / 2.0)) * [Math]::Cos($radLeft)
    $rx2 = $cx + ($gap + $len) * [Math]::Sin($radLeft)
    $ry2 = $cy - ($gap + $len) * [Math]::Cos($radLeft)

    $rectGrad = New-Object System.Drawing.RectangleF($cx, [float]($ry2 - 30.0), [float]($rx2 - $cx + 60.0), [float]($cy - $ry2 + 60.0))
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint top
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald base
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penRight, [float]$rx1, [float]$ry1, [float]$rx2, [float]$ry2)
    $penRight.Dispose()
    $brushGrad.Dispose()

    # 4. Central Nexus: Precision Vital Emerald Diamond / Cardio Node
    $nodeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.RectangleF($cx - 24.0, $cy - 24.0, 48.0, 48.0)),
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $diamond = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = 26.0
    $diamond.AddPolygon([System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx, $cy - $d),
        [System.Drawing.PointF]::new($cx + $d, $cy),
        [System.Drawing.PointF]::new($cx, $cy + $d),
        [System.Drawing.PointF]::new($cx - $d, $cy)
    ))
    $g.FillPath($nodeBrush, $diamond)
    $nodeBrush.Dispose()
    $diamond.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# VARIANT B: "The Heartbeat Wing Y (Continuous Cardio Flow)"
# The left branch descends gracefully, meets the stem at center,
# while the right branch incorporates an unmistakable, razor-sharp ECG pulse!
# The ECG wave is sculpted directly into the right wing's trajectory.
# -------------------------------------------------------------------------
function Render-VariantB([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 82.0

    # Main Spine (Left Wing + Stem): Solid Pure White
    # Top-Left (310, 240) -> Center (512, 470) -> Bottom (512, 780)
    $pathSpine = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathSpine.AddLine(315.0, 245.0, 512.0, 465.0)
    $pathSpine.AddLine(512.0, 465.0, 512.0, 775.0)

    $penSpine = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penSpine.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penSpine, $pathSpine)
    $penSpine.Dispose()
    $pathSpine.Dispose()

    # Right Wing: Vital Emerald ECG Cardio Wave
    # Emanates from the nexus (512, 465) with a clean 24px negative cut,
    # then steps:
    # 1. Base takeoff: (545, 435) -> (590, 395)
    # 2. Cardiac pulse spike UP: (590, 395) -> (640, 240) (The R-Peak!)
    # 3. Pulse drop / rebound: (640, 240) -> (680, 330) -> (730, 280)
    # Wait, let's create a beautifully sculpted cardio wave right arm:
    $pathCardio = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(545.0, 435.0),
        [System.Drawing.PointF]::new(595.0, 390.0),
        [System.Drawing.PointF]::new(645.0, 230.0), # The Cardio Peak!
        [System.Drawing.PointF]::new(690.0, 350.0), # Valley
        [System.Drawing.PointF]::new(740.0, 270.0)  # Wing Terminal
    )
    $pathCardio.AddLines($pts)

    $rectGrad = New-Object System.Drawing.RectangleF(530.0, 210.0, 240.0, 260.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penCardio = [System.Drawing.Pen]::new($brushGrad, [float]68.0)
    $penCardio.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penCardio.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penCardio.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penCardio, $pathCardio)
    $penCardio.Dispose()
    $brushGrad.Dispose()
    $pathCardio.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# VARIANT C: "The Cardio-Prism Y" (The Ultimate Minimalist Brand)
# Two intersecting fluid wings + central ECG heartbeat bridge:
# Left wing: Smooth athletic curve from top-left, bending into stem.
# Right wing: Mirror curve from top-right, meeting stem.
# At the junction, they fuse into a single solid 112px trunk!
# Above the junction, inside the V, an elegant minimalist heartbeat waveform
# pulses between the two wings in glowing mint.
# -------------------------------------------------------------------------
function Render-VariantC([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    # Single unified stem (512, 480) to (512, 775)
    # Left wing curves from (300, 250) down to (512, 480)
    # Right wing curves from (724, 250) down to (512, 480)
    $strokeW = 92.0

    # 1. Stem (Unified crisp white)
    $penStem = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Flat
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 480.0, 512.0, 775.0)
    $penStem.Dispose()

    # 2. Left Wing (Pure White)
    $pLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pLeft.AddBezier(
        [System.Drawing.PointF]::new(310.0, 250.0),
        [System.Drawing.PointF]::new(380.0, 360.0),
        [System.Drawing.PointF]::new(470.0, 450.0),
        [System.Drawing.PointF]::new(512.0, 480.0)
    )
    $penLeft = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Flat
    $g.DrawPath($penLeft, $pLeft)
    $penLeft.Dispose()
    $pLeft.Dispose()

    # 3. Right Wing (Vital Emerald to Mint Gradient)
    $pRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pRight.AddBezier(
        [System.Drawing.PointF]::new(714.0, 250.0),
        [System.Drawing.PointF]::new(644.0, 360.0),
        [System.Drawing.PointF]::new(554.0, 450.0),
        [System.Drawing.PointF]::new(512.0, 480.0)
    )
    $rectGrad = New-Object System.Drawing.RectangleF(500.0, 230.0, 230.0, 270.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penRight, $pRight)
    $penRight.Dispose()
    $brushGrad.Dispose()
    $pRight.Dispose()

    # Redraw junction node smooth
    $jBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillEllipse($jBrush, [float](512.0 - ($strokeW / 2.0)), [float](480.0 - ($strokeW / 2.0)), [float]$strokeW, [float]$strokeW)
    $jBrush.Dispose()

    # 4. In the V, an elegant floating vital node: A precision glowing Emerald Heartbeat Diamond
    $dSize = 32.0
    $diaBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        (New-Object System.Drawing.RectangleF(512.0 - $dSize, 360.0 - $dSize, $dSize * 2.0, $dSize * 2.0)),
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $diaPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    $diaPath.AddPolygon([System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(512.0, 360.0 - $dSize),
        [System.Drawing.PointF]::new(512.0 + $dSize, 360.0),
        [System.Drawing.PointF]::new(512.0, 360.0 + $dSize),
        [System.Drawing.PointF]::new(512.0 - $dSize, 360.0)
    ))
    $g.FillPath($diaBrush, $diaPath)
    $diaBrush.Dispose()
    $diaPath.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# VARIANT D: "The Asymmetric Kinetic Y" (Athletic Blade & Dynamic Pulse Wing)
# Clean, modern, athletic:
# Left Wing + Stem: White solid athletic blade.
# Right Wing: Dynamic floating Emerald wing (offset, sporty, forward-moving).
# -------------------------------------------------------------------------
function Render-VariantD([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 100.0

    # 1. Left Wing + Stem (Continuous White)
    $pathSpine = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathSpine.AddLine(310.0, 255.0, 512.0, 475.0)
    $pathSpine.AddLine(512.0, 475.0, 512.0, 775.0)

    $penSpine = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penSpine.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penSpine, $pathSpine)
    $penSpine.Dispose()
    $pathSpine.Dispose()

    # 2. Right Wing: Offset Emerald Blade with athletic 32px negative-space notch
    $rectGrad = New-Object System.Drawing.RectangleF(530.0, 230.0, 230.0, 260.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    # Starts at (555, 432) leaving a crisp 34px gap, extending to (725, 255)
    $g.DrawLine($penRight, 555.0, 432.0, 725.0, 255.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-VariantA "C:\develop\yhealth\logo_concepts\variant_a.png"
Render-VariantB "C:\develop\yhealth\logo_concepts\variant_b.png"
Render-VariantC "C:\develop\yhealth\logo_concepts\variant_c.png"
Render-VariantD "C:\develop\yhealth\logo_concepts\variant_d.png"
"Rendered Variants A, B, C, D"
