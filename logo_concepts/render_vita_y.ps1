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
# VITA-Y PRECISION VECTOR ENGINE
# -------------------------------------------------------------------------
function Render-VitaY([string]$outputPath, [bool]$isKinetic, [float]$seamWidth) {
    $c = Init-DarkCanvas
    $g = $c.Graphics
    $bmp = $c.Bitmap

    $cx = 512.0
    $halfSeam = $seamWidth / 2.0
    $stemHalfW = 58.0   # Each side of trunk is 58px wide (total trunk = 116px + seam)
    $stemBot = 775.0
    $junctionY = 470.0
    $strokeRadius = 48.0 # Bottom cap radius

    # Wing Endpoints
    $topL_X = 295.0
    $topL_Y = 245.0

    $topR_X = 729.0
    $topR_Y = if ($isKinetic) { 210.0 } else { 245.0 }

    # Control points for the sweep
    $ctrlL_OutX = 350.0
    $ctrlL_OutY = 370.0
    $ctrlL_InX  = 440.0
    $ctrlL_InY  = 390.0

    $ctrlR_OutX = 674.0
    $ctrlR_OutY = if ($isKinetic) { 340.0 } else { 370.0 }
    $ctrlR_InX  = 584.0
    $ctrlR_InY  = if ($isKinetic) { 360.0 } else { 390.0 }

    # 1. LEFT WING & TRUNK HALF (Pure White)
    $pathL = New-Object System.Drawing.Drawing2D.GraphicsPath
    
    # Outer wing tip
    $wTipRadius = 46.0
    $wTipAngle = 45.0 # Angle of rounded cap

    # Outer line down:
    # Outer corner of stem
    $stemOuterLX = $cx - $halfSeam - $stemHalfW
    $stemInnerLX = $cx - $halfSeam

    # Outer bezier curve from top-left tip down to outer stem
    $pathL.AddBezier(
        [System.Drawing.PointF]::new($topL_X - 32.0, $topL_Y + 32.0),
        [System.Drawing.PointF]::new($ctrlL_OutX, $ctrlL_OutY),
        [System.Drawing.PointF]::new($stemOuterLX, $junctionY),
        [System.Drawing.PointF]::new($stemOuterLX, $stemBot - $strokeRadius)
    )
    # Bottom outer arc to bottom edge
    $pathL.AddArc($stemOuterLX, $stemBot - ($strokeRadius * 2.0), ($strokeRadius * 2.0), ($strokeRadius * 2.0), 90, 90)
    # Flat bottom edge to inner seam
    $pathL.AddLine($stemOuterLX + $strokeRadius, $stemBot, $stemInnerLX, $stemBot)
    # Vertical inner seam edge up to junction
    $pathL.AddLine($stemInnerLX, $stemBot, $stemInnerLX, $junctionY)
    # Inner wing curve back up to inner top-left
    $pathL.AddBezier(
        [System.Drawing.PointF]::new($stemInnerLX, $junctionY),
        [System.Drawing.PointF]::new($ctrlL_InX, $ctrlL_InY),
        [System.Drawing.PointF]::new(370.0, 300.0),
        [System.Drawing.PointF]::new($topL_X + 32.0, $topL_Y - 32.0)
    )
    # Top rounded cap
    $pathL.AddArc($topL_X - 32.0, $topL_Y - 32.0, 64.0, 64.0, 225, 180)
    $pathL.CloseFigure()

    $brushL = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($brushL, $pathL)
    $brushL.Dispose()
    $pathL.Dispose()

    # 2. RIGHT WING & TRUNK HALF (Vital Emerald to Mint Gradient)
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath

    $stemOuterRX = $cx + $halfSeam + $stemHalfW
    $stemInnerRX = $cx + $halfSeam

    $pathR.AddBezier(
        [System.Drawing.PointF]::new($topR_X + 32.0, $topR_Y + 32.0),
        [System.Drawing.PointF]::new($ctrlR_OutX, $ctrlR_OutY),
        [System.Drawing.PointF]::new($stemOuterRX, $junctionY),
        [System.Drawing.PointF]::new($stemOuterRX, $stemBot - $strokeRadius)
    )
    $pathR.AddArc($stemOuterRX - ($strokeRadius * 2.0), $stemBot - ($strokeRadius * 2.0), ($strokeRadius * 2.0), ($strokeRadius * 2.0), 0, 90)
    $pathR.AddLine($stemOuterRX - $strokeRadius, $stemBot, $stemInnerRX, $stemBot)
    $pathR.AddLine($stemInnerRX, $stemBot, $stemInnerRX, $junctionY)
    $pathR.AddBezier(
        [System.Drawing.PointF]::new($stemInnerRX, $junctionY),
        [System.Drawing.PointF]::new($ctrlR_InX, $ctrlR_InY),
        [System.Drawing.PointF]::new(654.0, 300.0),
        [System.Drawing.PointF]::new($topR_X - 32.0, $topR_Y - 32.0)
    )
    $pathR.AddArc($topR_X - 32.0, $topR_Y - 32.0, 64.0, 64.0, 315, 180)
    $pathR.CloseFigure()

    $rectGrad = [System.Drawing.RectangleF]::new(
        $cx,
        [float]($topR_Y - 40.0),
        [float]($topR_X - $cx + 80.0),
        [float]($stemBot - $topR_Y + 80.0)
    )
    $brushR = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectGrad,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # #34D399 Radiant Mint
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # #10B981 Vital Emerald
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPath($brushR, $pathR)
    $brushR.Dispose()
    $pathR.Dispose()

    # 3. Clean rounded inner junction fillet
    # In the V-notch at (512, 470), give it a smooth circular apex
    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-VitaY "C:\develop\yhealth\logo_concepts\vitay_sym12.png" $false 12.0
Render-VitaY "C:\develop\yhealth\logo_concepts\vitay_sym18.png" $false 18.0
Render-VitaY "C:\develop\yhealth\logo_concepts\vitay_kin12.png" $true 12.0
"Rendered Vita-Y Variants"
