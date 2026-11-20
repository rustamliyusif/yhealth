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
    $rect = [System.Drawing.RectangleF]::new($margin, $margin, $w, $w)

    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 10, 36, 24), # Deep Forest Emerald
        [System.Drawing.Color]::FromArgb(255, 4, 16, 11),  # Obsidian Forest
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
# MASTER CONCEPT W1: "The Pure Vitality Wings (Flawless Symmetry & Seam)"
# Smooth geometric curves.
# Left Wing: Pure White
# Right Wing: Vital Emerald (#10B981) to Electric Mint (#34D399)
# Merging into a grounded vertical stem with a 14px surgical seam.
# -------------------------------------------------------------------------
function Render-W1([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 84.0
    $gap = 12.0 # Half-gap of seam = 12px, so full gap = 24px

    # Left Wing:
    # Starts at (305, 245)
    # Curves down to (512 - gap, 500)
    # Straight vertical down to (512 - gap, 775)
    $pathL = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(310.0, 245.0),
        [System.Drawing.PointF]::new(370.0, 370.0),
        [System.Drawing.PointF]::new(512.0 - $gap, 440.0),
        [System.Drawing.PointF]::new(512.0 - $gap, 510.0)
    )
    $pathL.AddLine(512.0 - $gap, 510.0, 512.0 - $gap, 775.0)

    $penL = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penL.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penL.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penL.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penL, $pathL)
    $penL.Dispose()
    $pathL.Dispose()

    # Right Wing:
    # Starts at (714, 245)
    # Curves down to (512 + gap, 500)
    # Straight vertical down to (512 + gap, 775)
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(714.0, 245.0),
        [System.Drawing.PointF]::new(654.0, 370.0),
        [System.Drawing.PointF]::new(512.0 + $gap, 440.0),
        [System.Drawing.PointF]::new(512.0 + $gap, 510.0)
    )
    $pathR.AddLine(512.0 + $gap, 510.0, 512.0 + $gap, 775.0)

    $rectGrad = [System.Drawing.RectangleF]::new(480.0, 220.0, 280.0, 580.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # #34D399 Mint top
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # #10B981 Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $penR = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penR.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penR, $pathR)
    $penR.Dispose()
    $brushGrad.Dispose()
    $pathR.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# MASTER CONCEPT W2: "The Rising Cardio Wings (Athletic Surge)"
# The right wing rises higher and faster (surging up to Y=210),
# symbolizing peak heart performance, athletic progression, and vitality!
# In the center junction, the left and right wings merge into a single solid 108px trunk!
# -------------------------------------------------------------------------
function Render-W2([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 96.0

    # 1. Stem: Single solid White trunk from (512, 480) to (512, 775)
    $penStem = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 480.0, 512.0, 775.0)
    $penStem.Dispose()

    # 2. Left Wing (Pure White): Curves from (305, 260) to (512, 480)
    $pathL = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(310.0, 260.0),
        [System.Drawing.PointF]::new(370.0, 380.0),
        [System.Drawing.PointF]::new(460.0, 460.0),
        [System.Drawing.PointF]::new(512.0, 480.0)
    )
    $penL = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penL.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penL.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penL, $pathL)
    $penL.Dispose()
    $pathL.Dispose()

    # 3. Right Wing (Vital Emerald): Sweeps from nexus (512, 480) up to (730, 215)
    # Notice: It reaches higher (215 vs 260), with a more dynamic aerodynamic angle!
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(535.0, 455.0),
        [System.Drawing.PointF]::new(580.0, 390.0),
        [System.Drawing.PointF]::new(660.0, 305.0),
        [System.Drawing.PointF]::new(730.0, 215.0)
    )

    $rectGrad = [System.Drawing.RectangleF]::new(510.0, 200.0, 240.0, 280.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint #34D399
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald #10B981
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penR = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penR.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawPath($penR, $pathR)
    $penR.Dispose()
    $brushGrad.Dispose()
    $pathR.Dispose()

    # Redraw junction node smooth
    $jBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillEllipse($jBrush, [float](512.0 - ($strokeW / 2.0)), [float](480.0 - ($strokeW / 2.0)), [float]$strokeW, [float]$strokeW)
    $jBrush.Dispose()

    # Central Vital Pulse Bead: A radiant Mint-Emerald heart-node right in the junction
    $bSize = 18.0
    $bBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        ([System.Drawing.RectangleF]::new(512.0 - $bSize, 480.0 - $bSize, $bSize * 2.0, $bSize * 2.0)),
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillEllipse($bBrush, [float](512.0 - $bSize), [float](480.0 - $bSize), [float]($bSize * 2.0), [float]($bSize * 2.0))
    $bBrush.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# MASTER CONCEPT W3: "The Cardio-Loop Ribbon Y (Continuous Infinity Health)"
# World-class continuous ribbon:
# The stem and left wing form a continuous sweeping path.
# The right wing loops over the stem with a sleek 28px negative-space mask,
# creating architectural depth and motion.
# -------------------------------------------------------------------------
function Render-W3([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $strokeW = 96.0

    # 1. Continuous White Spine: Left Wing + Stem
    $pathSpine = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathSpine.AddBezier(
        [System.Drawing.PointF]::new(310.0, 250.0),
        [System.Drawing.PointF]::new(370.0, 370.0),
        [System.Drawing.PointF]::new(512.0, 440.0),
        [System.Drawing.PointF]::new(512.0, 520.0)
    )
    $pathSpine.AddLine(512.0, 520.0, 512.0, 775.0)

    $penSpine = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penSpine.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penSpine.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penSpine, $pathSpine)
    $penSpine.Dispose()
    $pathSpine.Dispose()

    # 2. Right Wing with precision mask:
    # Curves from (720, 240) down towards (512, 470)
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(724.0, 240.0),
        [System.Drawing.PointF]::new(664.0, 360.0),
        [System.Drawing.PointF]::new(580.0, 420.0),
        [System.Drawing.PointF]::new(550.0, 445.0)
    )

    $rectGrad = [System.Drawing.RectangleF]::new(520.0, 220.0, 220.0, 250.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penR = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penR.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penR.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penR, $pathR)
    $penR.Dispose()
    $brushGrad.Dispose()
    $pathR.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-W1 "C:\develop\yhealth\logo_concepts\master_w1.png"
Render-W2 "C:\develop\yhealth\logo_concepts\master_w2.png"
Render-W3 "C:\develop\yhealth\logo_concepts\master_w3.png"
"Rendered Master W1, W2, W3"
