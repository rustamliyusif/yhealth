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

function Render-PerfectF([string]$outputPath, [string]$theme, [bool]$showPulseNode) {
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

    $isDark = ($theme -eq "dark")

    if ($isDark) {
        # Deep Forest Emerald Background
        $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $rect,
            [System.Drawing.Color]::FromArgb(255, 11, 38, 25), # #0B2619 Deep Forest
            [System.Drawing.Color]::FromArgb(255, 4, 16, 11),  # #04100B Obsidian
            [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
        )
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        # Hairline ambient border
        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(26, 255, 255, 255), [float]2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    } else {
        # Pristine Clinical White / Calming Soft Green background
        $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 246, 250, 248))
        $g.FillPath($bgBrush, $sqPath)
        $bgBrush.Dispose()

        # Subtle border
        $rimPen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(35, 11, 38, 25), [float]2.0)
        $innerPath = Create-RoundedRectanglePath ($margin + 2.0) ($margin + 2.0) ($w - 4.0) ($w - 4.0) ($radius - 2.0)
        $g.DrawPath($rimPen, $innerPath)
        $rimPen.Dispose()
        $innerPath.Dispose()
    }
    $sqPath.Dispose()

    # -------------------------------------------------------------
    # GEOMETRY OF THE TWO VITALITY WINGS (THE VITA-Y)
    # -------------------------------------------------------------
    $cx = 512.0
    $junctionY = 480.0
    $stemBot = 775.0
    $stemHalfW = 52.0 # Total stem width = 104px

    # Left Wing (White in dark mode, Deep Forest in light mode)
    $pathL = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Outer contour:
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(275.0, 255.0),
        [System.Drawing.PointF]::new(355.0, 385.0),
        [System.Drawing.PointF]::new($cx - $stemHalfW, 480.0),
        [System.Drawing.PointF]::new($cx - $stemHalfW, $stemBot - 30.0)
    )
    # Bottom outer round cap
    $pathL.AddBezier(
        [System.Drawing.PointF]::new($cx - $stemHalfW, $stemBot - 30.0),
        [System.Drawing.PointF]::new($cx - $stemHalfW, $stemBot),
        [System.Drawing.PointF]::new($cx, $stemBot),
        [System.Drawing.PointF]::new($cx, $stemBot)
    )
    # Vertical centerline up to junction
    $pathL.AddLine($cx, $stemBot, $cx, $junctionY)
    # Inner wing contour back up to top-left
    $pathL.AddBezier(
        [System.Drawing.PointF]::new($cx, $junctionY),
        [System.Drawing.PointF]::new(440.0, 410.0),
        [System.Drawing.PointF]::new(365.0, 310.0),
        [System.Drawing.PointF]::new(335.0, 225.0)
    )
    # Top-left rounded cap
    $pathL.AddBezier(
        [System.Drawing.PointF]::new(335.0, 225.0),
        [System.Drawing.PointF]::new(305.0, 212.0),
        [System.Drawing.PointF]::new(265.0, 228.0),
        [System.Drawing.PointF]::new(275.0, 255.0)
    )
    $pathL.CloseFigure()

    $brushL = if ($isDark) {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    } else {
        New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 11, 38, 25)) # Deep Forest
    }
    $g.FillPath($brushL, $pathL)
    $brushL.Dispose()
    $pathL.Dispose()

    # Right Wing (Radiant Vital Emerald Gradient)
    $pathR = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Outer contour:
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(749.0, 255.0),
        [System.Drawing.PointF]::new(669.0, 385.0),
        [System.Drawing.PointF]::new($cx + $stemHalfW, 480.0),
        [System.Drawing.PointF]::new($cx + $stemHalfW, $stemBot - 30.0)
    )
    # Bottom outer round cap
    $pathR.AddBezier(
        [System.Drawing.PointF]::new($cx + $stemHalfW, $stemBot - 30.0),
        [System.Drawing.PointF]::new($cx + $stemHalfW, $stemBot),
        [System.Drawing.PointF]::new($cx, $stemBot),
        [System.Drawing.PointF]::new($cx, $stemBot)
    )
    # Vertical centerline up to junction
    $pathR.AddLine($cx, $stemBot, $cx, $junctionY)
    # Inner wing contour back up to top-right
    $pathR.AddBezier(
        [System.Drawing.PointF]::new($cx, $junctionY),
        [System.Drawing.PointF]::new(584.0, 410.0),
        [System.Drawing.PointF]::new(659.0, 310.0),
        [System.Drawing.PointF]::new(689.0, 225.0)
    )
    # Top-right rounded cap
    $pathR.AddBezier(
        [System.Drawing.PointF]::new(689.0, 225.0),
        [System.Drawing.PointF]::new(719.0, 212.0),
        [System.Drawing.PointF]::new(759.0, 228.0),
        [System.Drawing.PointF]::new(749.0, 255.0)
    )
    $pathR.CloseFigure()

    $rectR = [System.Drawing.RectangleF]::new(
        $cx,
        210.0,
        [float](760.0 - $cx),
        [float]($stemBot - 210.0 + 20.0)
    )
    $brushR = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectR,
        [System.Drawing.Color]::FromArgb(255, 52, 211, 153), # Mint #34D399 (top vitality)
        [System.Drawing.Color]::FromArgb(255, 16, 185, 129), # Emerald #10B981 (base life force)
        [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
    )
    $g.FillPath($brushR, $pathR)
    $brushR.Dispose()
    $pathR.Dispose()

    # Precision Center Seam (Negative Space Hairline):
    # Cuts down the stem from junction to bottom to separate the two wings with laser precision
    $seamColor = if ($isDark) {
        [System.Drawing.Color]::FromArgb(255, 11, 38, 25)
    } else {
        [System.Drawing.Color]::FromArgb(255, 246, 250, 248)
    }
    $seamPen = [System.Drawing.Pen]::new($seamColor, [float]12.0)
    $seamPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $seamPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawLine($seamPen, $cx, $junctionY - 6.0, $cx, $stemBot + 14.0)
    $seamPen.Dispose()

    # Optional Vital Pulse Core:
    if ($showPulseNode) {
        # A radiant Mint-Emerald diamond/bead sitting in the V notch
        $dSize = 24.0
        $dY = $junctionY - 10.0
        $diamond = New-Object System.Drawing.Drawing2D.GraphicsPath
        $diamond.AddPolygon([System.Drawing.PointF[]]@(
            [System.Drawing.PointF]::new($cx, $dY - $dSize),
            [System.Drawing.PointF]::new($cx + $dSize, $dY),
            [System.Drawing.PointF]::new($cx, $dY + $dSize),
            [System.Drawing.PointF]::new($cx - $dSize, $dY)
        ))
        $dRect = [System.Drawing.RectangleF]::new([float]($cx - $dSize), [float]($dY - $dSize), [float]($dSize * 2.0), [float]($dSize * 2.0))
        $dBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
            $dRect,
            [System.Drawing.Color]::FromArgb(255, 52, 211, 153),
            [System.Drawing.Color]::FromArgb(255, 16, 185, 129),
            [System.Drawing.Drawing2D.LinearGradientMode]::Vertical
        )
        $g.FillPath($dBrush, $diamond)
        $dBrush.Dispose()
        $diamond.Dispose()
    }

    $g.Dispose()
    $bmp.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

Render-PerfectF "C:\develop\yhealth\logo_concepts\perfect_f_dark.png" "dark" $false
Render-PerfectF "C:\develop\yhealth\logo_concepts\perfect_f_dark_node.png" "dark" $true
Render-PerfectF "C:\develop\yhealth\logo_concepts\perfect_f_light.png" "light" $false
Render-PerfectF "C:\develop\yhealth\logo_concepts\perfect_f_light_node.png" "light" $true
"Rendered Perfect F variants"
