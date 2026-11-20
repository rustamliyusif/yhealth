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
        [System.Drawing.Color]::FromArgb(255, 10, 34, 22), # Luxury Deep Forest Green #0A2216
        [System.Drawing.Color]::FromArgb(255, 3, 14, 9),   # #030E09 Obsidian
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()

    # Hairline outer rim
    $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(28, 255, 255, 255), [float]2.0)
    $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
    $g.DrawPath($rimPen, $innerPath)
    $rimPen.Dispose()
    $innerPath.Dispose()
    $sqPath.Dispose()

    return @{ Bitmap = $bmp; Graphics = $g }
}

# -------------------------------------------------------------------------
# CONCEPT E: "The Isometric Hex-Prism Y" (Dimensional Medical Tech)
# 3 Faceted Rhombuses that form an architectural 3D Y:
# Top-Left: Pure White (Clinical Trust, Precision)
# Top-Right: Radiant Mint-Emerald (Life, Vitality, Movement)
# Bottom-Stem: Deep Emerald (Endurance, Longevity)
# Precision 18px negative space channels between them.
# -------------------------------------------------------------------------
function Render-ConceptE([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $cx = 512.0
    $cy = 500.0
    $R = 260.0    # Outer radius of hexagon
    $gap = 14.0   # Negative space channel half-width
    $cr = 28.0    # Corner rounding

    # In a hexagon with flat top/bottom or pointy top/bottom:
    # A standard isometric cube Y has angles: 90 deg (down), 210 deg (top-left), 330 deg (top-right).
    # Wait, in standard 0=right, 90=down, 180=left, 270=up:
    # Angle 1 (Bottom): 90 deg (straight down)
    # Angle 2 (Top-Left): 210 deg (-150 deg)
    # Angle 3 (Top-Right): 330 deg (-30 deg)
    # The edges meeting at the center form a perfect Y!

    # Let's draw the 3 rhombuses with rounded corners:
    # 1. Top-Left Rhombus (White)
    $pTL = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Center-offset vertex
    $v0 = [System.Drawing.PointF]::new($cx - $gap * 0.866, $cy - $gap * 0.5)
    # Top-Left outer vertex (at 210 deg)
    $v1 = [System.Drawing.PointF]::new($cx + $R * [Math]::Cos(210.0 * [Math]::PI / 180.0) - $gap * 0.5, $cy + $R * [Math]::Sin(210.0 * [Math]::PI / 180.0))
    # Top-Center vertex (at 270 deg)
    $v2 = [System.Drawing.PointF]::new($cx - $gap * 0.866, $cy - $R - $gap * 0.5)
    # Left-Center vertex (at 150 deg)
    $v3 = [System.Drawing.PointF]::new($cx + $R * [Math]::Cos(150.0 * [Math]::PI / 180.0) - $gap * 0.5, $cy + $R * [Math]::Sin(150.0 * [Math]::PI / 180.0) - $gap * 0.5)

    # Let's use simple polygon coordinates for precision:
    # Top-Left Face
    $ptsTL = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx - 16.0, $cy - 10.0),
        [System.Drawing.PointF]::new($cx - 16.0, $cy - 240.0),
        [System.Drawing.PointF]::new($cx - 220.0, $cy - 125.0),
        [System.Drawing.PointF]::new($cx - 220.0, $cy + 105.0)
    )
    $brushTL = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPolygon($brushTL, $ptsTL)
    $brushTL.Dispose()

    # Top-Right Face (Vital Emerald to Mint Gradient)
    $ptsTR = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx + 16.0, $cy - 10.0),
        [System.Drawing.PointF]::new($cx + 16.0, $cy - 240.0),
        [System.Drawing.PointF]::new($cx + 220.0, $cy - 125.0),
        [System.Drawing.PointF]::new($cx + 220.0, $cy + 105.0)
    )
    $rectTR = New-Object System.Drawing.RectangleF($cx, $cy - 240.0, 240.0, 360.0)
    $brushTR = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectTR,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint #34D399
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald #10B981
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPolygon($brushTR, $ptsTR)
    $brushTR.Dispose()

    # Bottom Face (Deep Vital Emerald)
    $ptsB = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($cx - 200.0, $cy + 130.0),
        [System.Drawing.PointF]::new($cx, $cy + 25.0),
        [System.Drawing.PointF]::new($cx + 200.0, $cy + 130.0),
        [System.Drawing.PointF]::new($cx, $cy + 245.0)
    )
    $rectB = New-Object System.Drawing.RectangleF($cx - 210.0, $cy + 20.0, 420.0, 230.0)
    $brushB = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectB,
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Color]::FromArgb(255, 6, 95, 70), # Deep Forest Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPolygon($brushB, $ptsB)
    $brushB.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# CONCEPT F: "The Kinetic Cardio-Wings Y"
# Two curved athletic aerodynamic wings that converge at a solid vertical stem:
# Resembles a soaring bird of health / two athletic arms reaching for the sky /
# an upward vital pulse wave.
# Left Wing: Pure White.
# Right Wing: Radiant Vital Emerald with Mint tip.
# In the center: A sharp, crisp negative space heart-line.
# -------------------------------------------------------------------------
function Render-ConceptF([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    # Wing 1: Left Wing & Stem (Pure White)
    # Starts at top left (270, 250), sweeps down into a powerful vertical stem at center
    $pathLeft = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Outer contour:
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(280.0, 250.0),
        [System.Drawing.PointF]::new(360.0, 380.0),
        [System.Drawing.PointF]::new(460.0, 480.0),
        [System.Drawing.PointF]::new(460.0, 770.0)
    )
    # Bottom round cap to (512, 770)
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(460.0, 770.0),
        [System.Drawing.PointF]::new(460.0, 800.0),
        [System.Drawing.PointF]::new(512.0, 800.0),
        [System.Drawing.PointF]::new(512.0, 770.0)
    )
    # Center spine line up to junction (512, 510)
    $pathLeft.AddLine(512.0, 770.0, 512.0, 500.0)
    # Inner contour curving back to top-left
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(512.0, 500.0),
        [System.Drawing.PointF]::new(440.0, 420.0),
        [System.Drawing.PointF]::new(370.0, 310.0),
        [System.Drawing.PointF]::new(340.0, 220.0)
    )
    # Top tip rounded cap
    $pathLeft.AddBezier(
        [System.Drawing.PointF]::new(340.0, 220.0),
        [System.Drawing.PointF]::new(310.0, 210.0),
        [System.Drawing.PointF]::new(270.0, 225.0),
        [System.Drawing.PointF]::new(280.0, 250.0)
    )
    $pathLeft.CloseFigure()

    $brushWhite = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushWhite, $pathLeft)
    $brushWhite.Dispose()
    $pathLeft.Dispose()

    # Wing 2: Right Wing & Stem (Vital Emerald)
    $pathRight = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(744.0, 250.0),
        [System.Drawing.PointF]::new(664.0, 380.0),
        [System.Drawing.PointF]::new(564.0, 480.0),
        [System.Drawing.PointF]::new(564.0, 770.0)
    )
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(564.0, 770.0),
        [System.Drawing.PointF]::new(564.0, 800.0),
        [System.Drawing.PointF]::new(512.0, 800.0),
        [System.Drawing.PointF]::new(512.0, 770.0)
    )
    $pathRight.AddLine(512.0, 770.0, 512.0, 500.0)
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(512.0, 500.0),
        [System.Drawing.PointF]::new(584.0, 420.0),
        [System.Drawing.PointF]::new(654.0, 310.0),
        [System.Drawing.PointF]::new(684.0, 220.0)
    )
    $pathRight.AddBezier(
        [System.Drawing.PointF]::new(684.0, 220.0),
        [System.Drawing.PointF]::new(714.0, 210.0),
        [System.Drawing.PointF]::new(754.0, 225.0),
        [System.Drawing.PointF]::new(744.0, 250.0)
    )
    $pathRight.CloseFigure()

    $rectRight = New-Object System.Drawing.RectangleF(512.0, 210.0, 250.0, 600.0)
    $brushRight = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectRight,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPath($brushRight, $pathRight)
    $brushRight.Dispose()
    $pathRight.Dispose()

    # Center Precision Negative-Space Cut / Heartbeat Seam:
    # A sleek 10px hairline down the center spine that gives it surgical high-tech precision!
    $seamPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 10, 34, 22), [float]14.0)
    $seamPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $seamPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($seamPen, 512.0, 490.0, 512.0, 785.0)
    $seamPen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# CONCEPT G: "The VITA-PULSE Monogram" (The Continuous Heartbeat Y)
# A clean, thick athletic stroke where the entire letter is drawn in ONE continuous stroke:
# Enters from top-left, curves down to form an ECG heart spike at center,
# plunges into the stem, and leaps into the right arm.
# Let's test a clean stroke geometry.
# -------------------------------------------------------------------------
function Render-ConceptG([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    # Left Arm: from (310, 250) down to (512, 500)
    # Stem: from (512, 500) to (512, 780)
    # Right Arm: from (512, 500) up to (714, 250)
    # Now let's integrate the ECG pulse into the V:
    # An active cardio wave embedded cleanly:
    $strokeW = 96.0

    # 1. Left Arm + Stem (Crisp White)
    $pathWhite = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathWhite.AddLine(310.0, 250.0, 512.0, 490.0)
    $pathWhite.AddLine(512.0, 490.0, 512.0, 780.0)

    $penWhite = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penWhite.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penWhite, $pathWhite)
    $penWhite.Dispose()
    $pathWhite.Dispose()

    # 2. Right Arm (Emerald Gradient) with a precision athletic notch at nexus
    $rectGrad = New-Object System.Drawing.RectangleF(510.0, 230.0, 230.0, 280.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

    # Right arm starts from (550, 445) to leave a surgical 28px air-gap, ending at (714, 250)
    $g.DrawLine($penRight, 550.0, 445.0, 714.0, 250.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    # 3. Add an upward Vitality Pulse Arrow / Heartbeat Apex:
    # At the top of the stem, right in the nexus:
    # A glowing Mint-Emerald chevron pointing UP (symbolizing health improvement & vitality)
    $chevPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 52, 211, 153), [float]18.0)
    $chevPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $chevPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $chevPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    # Chevron points:
    $chevPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(475.0, 480.0),
        [System.Drawing.PointF]::new(512.0, 420.0),
        [System.Drawing.PointF]::new(549.0, 480.0)
    )
    $g.DrawLines($chevPen, $chevPts)
    $chevPen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# -------------------------------------------------------------------------
# CONCEPT H: "The VITA-RING (Health & Fitness Loop Monogram)"
# A world-class ring / shield concept:
# An unbroken circular activity tracker / health ring (Apple Health / Oura / Whoop ring)
# Inside the ring, the Y monogram is formed by two athletic intersecting ribbons:
# Left arm + stem = Pure White ribbon
# Right arm = Vital Emerald ribbon
# And the ring has a subtle cardio pulse gap at the top!
# -------------------------------------------------------------------------
function Render-ConceptH([string]$outputPath) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $cx = 512.0
    $cy = 512.0

    # 1. Outer Activity Ring (Vital Emerald Gradient with cardio gap at top)
    $ringRect = New-Object System.Drawing.RectangleF(180.0, 180.0, 664.0, 664.0)
    $ringGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $ringRect,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $ringPen = [System.Drawing.Pen]::new($ringGrad, [float]44.0)
    $ringPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $ringPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

    # Arc from -60 deg to 240 deg (leaving an athletic 60 deg opening at the top)
    $g.DrawArc($ringPen, $ringRect, -65.0, 310.0)
    $ringPen.Dispose()
    $ringGrad.Dispose()

    # 2. Inside the Ring: The Y Monogram
    $strokeW = 68.0

    # Left Wing + Stem (Pure White)
    $pathWhite = New-Object System.Drawing.Drawing2D.GraphicsPath
    $pathWhite.AddLine(350.0, 330.0, 512.0, 500.0)
    $pathWhite.AddLine(512.0, 500.0, 512.0, 690.0)

    $penWhite = [System.Drawing.Pen]::new([System.Drawing.Color]::White, [float]$strokeW)
    $penWhite.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penWhite.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
    $g.DrawPath($penWhite, $pathWhite)
    $penWhite.Dispose()
    $pathWhite.Dispose()

    # Right Wing (Emerald Gradient)
    $rectGrad = New-Object System.Drawing.RectangleF(510.0, 310.0, 180.0, 210.0)
    $brushGrad = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = [System.Drawing.Pen]::new($brushGrad, [float]$strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

    $g.DrawLine($penRight, 540.0, 465.0, 674.0, 330.0)
    $penRight.Dispose()
    $brushGrad.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-ConceptE "C:\develop\yhealth\logo_concepts\concept_e.png"
Render-ConceptF "C:\develop\yhealth\logo_concepts\concept_f.png"
Render-ConceptG "C:\develop\yhealth\logo_concepts\concept_g.png"
Render-ConceptH "C:\develop\yhealth\logo_concepts\concept_h.png"
"Rendered Concepts E, F, G, H"
