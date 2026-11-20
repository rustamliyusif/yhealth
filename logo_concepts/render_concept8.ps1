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

# --- CONCEPT 8A: The Sculptural Fluid Bio-Y ---
# A bespoke closed-path sculpted monogram with dynamic aerodynamic swelling and athletic curves.
# Formed by two intertwined fluid blades: White Left Blade (endurance, stability) + Emerald Right Blade (vitality, cardio surge).
function Render-Concept8A([string]$outputPath) {
    $size = 1024
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background: Luxury Forest Green
    $margin = 40.0
    $w = 1024.0 - (2.0 * $margin)
    $radius = $w * 0.24
    $sqPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 11, 46, 30),
        [System.Drawing.Color]::FromArgb(255, 4, 18, 12),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $sqPath)
    $bgBrush.Dispose()
    $sqPath.Dispose()

    # Hairline border
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(28, 255, 255, 255), 2.5)
    $innerSqPath = Create-RoundedRectanglePath ($margin + 3) ($margin + 3) ($w - 6) ($w - 6) ($radius - 3)
    $g.DrawPath($borderPen, $innerSqPath)
    $borderPen.Dispose()
    $innerSqPath.Dispose()

    # Blade 1: Left Wing & Stem (Crisp White)
    # Starts at top-left, sweeps with dynamic swelling curve down to center stem, rounded bottom
    $path1 = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path1.AddBezier(
        [System.Drawing.PointF]::new(260.0, 290.0),
        [System.Drawing.PointF]::new(350.0, 390.0),
        [System.Drawing.PointF]::new(460.0, 480.0),
        [System.Drawing.PointF]::new(470.0, 750.0)
    )
    $path1.AddArc(470.0, 710.0, 80.0, 80.0, 0, 180) # Bottom rounded cap
    $path1.AddBezier(
        [System.Drawing.PointF]::new(470.0, 750.0),
        [System.Drawing.PointF]::new(460.0, 520.0),
        [System.Drawing.PointF]::new(380.0, 420.0),
        [System.Drawing.PointF]::new(320.0, 230.0)
    )
    $path1.AddArc(260.0, 230.0, 60.0, 60.0, 270, -180) # Top-left rounded cap
    $path1.CloseFigure()

    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($whiteBrush, $path1)
    $whiteBrush.Dispose()
    $path1.Dispose()

    # Blade 2: Right Wing (Vibrant Vital Emerald to Mint Gradient)
    # Originates from the central junction and leaps upward-right like an athletic flame / pulse wave
    $rectRight = New-Object System.Drawing.RectangleF(470.0, 220.0, 300.0, 400.0)
    $gradRight = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectRight,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # #34D399 Mint top
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # #10B981 Emerald base
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )

    $path2 = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path2.AddBezier(
        [System.Drawing.PointF]::new(490.0, 500.0),
        [System.Drawing.PointF]::new(530.0, 440.0),
        [System.Drawing.PointF]::new(620.0, 340.0),
        [System.Drawing.PointF]::new(740.0, 240.0)
    )
    $path2.AddArc(710.0, 210.0, 60.0, 60.0, 45, 180) # Top-right cap
    $path2.AddBezier(
        [System.Drawing.PointF]::new(740.0, 280.0),
        [System.Drawing.PointF]::new(640.0, 380.0),
        [System.Drawing.PointF]::new(560.0, 480.0),
        [System.Drawing.PointF]::new(520.0, 560.0)
    )
    $path2.CloseFigure()

    $g.FillPath($gradRight, $path2)
    $gradRight.Dispose()
    $path2.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# --- CONCEPT 8B: The "Vitality Monogram" (Geometric Interlocking Precision Y) ---
# Perfect golden-ratio geometric construction:
# 3 Rounded Bars + 1 Cardio-Peak Diamond that creates an unforgettable modern monogram.
# Used by top global tech companies: Airbnb, Tesla, Uber, Wise.
function Render-Concept8B([string]$outputPath) {
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
        [System.Drawing.Color]::FromArgb(255, 12, 45, 30),
        [System.Drawing.Color]::FromArgb(255, 5, 20, 13),
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

    # GEOMETRY:
    # Golden ratio Y monogram with athletic forward tilt & ECG heartbeat diamond
    # Stem: X = 512, Y = 500 to 780. Stroke = 104px. Pure White.
    # Left Arm: from (305, 265) to (512, 490). Stroke = 104px. Pure White.
    # Right Arm: from (719, 265) to (535, 465). Stroke = 104px. Vital Emerald (#10B981).
    # Intersecting at the nexus with an athletic 32px negative-space notch,
    # and a glowing cardio pulse apex node.

    $strokeW = 104.0

    # 1. Stem (Pure White)
    $penStem = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penStem.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penStem.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penStem, 512.0, 485.0, 512.0, 775.0)
    $penStem.Dispose()

    # 2. Left Arm (Pure White)
    $penLeft = New-Object System.Drawing.Pen([System.Drawing.Color]::White, $strokeW)
    $penLeft.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penLeft.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($penLeft, 305.0, 265.0, 512.0, 485.0)
    $penLeft.Dispose()

    # 3. Right Arm (Vital Emerald #10B981 to Mint #34D399 Gradient)
    $rectArm = New-Object System.Drawing.RectangleF(512.0, 250.0, 240.0, 260.0)
    $brushArm = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectArm,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint
        [System.Drawing.Color]::FromArgb(255, 5, 150, 105),  # Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $penRight = New-Object System.Drawing.Pen($brushArm, $strokeW)
    $penRight.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $penRight.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    # Starts from (540, 455) to leave a precision 28px air-gap, ending at (719, 265)
    $g.DrawLine($penRight, 542.0, 453.0, 719.0, 265.0)
    $brushArm.Dispose()
    $penRight.Dispose()

    # 4. Cardio Pulse Apex (In the V of the Y):
    # A sleek, minimalist upward chevron / ECG pulse pulse peak:
    # Connecting the white left arm and the emerald right arm across the gap like a spark of life!
    $sparkPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 52, 211, 153), 20.0)
    $sparkPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $sparkPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $sparkPen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $sparkPts = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(460.0, 430.0),
        [System.Drawing.PointF]::new(512.0, 360.0), # Crisp cardiac peak in the center of the V
        [System.Drawing.PointF]::new(564.0, 430.0)
    )
    $g.DrawLines($sparkPen, $sparkPts)
    $sparkPen.Dispose()

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-Concept8A "C:\develop\yhealth\logo_concepts\concept8a.png"
Render-Concept8B "C:\develop\yhealth\logo_concepts\concept8b.png"
"Rendered Concepts 8A and 8B"
