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

function Draw-YHealthEmblem([System.Drawing.Graphics]$g, [float]$centerX, [float]$centerY, [float]$scale) {
    # Scale factor from 1024 base
    $s = $scale

    # 1. Outer dynamic fitness activity ring (soft white accent)
    $ringRadius = 310.0 * $s
    $ringPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(65, 255, 255, 255), (28.0 * $s))
    $ringPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $ringPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $g.DrawArc($ringPen, ($centerX - $ringRadius), ($centerY - $ringRadius), ($ringRadius * 2), ($ringRadius * 2), -70, 240)
    $ringPen.Dispose()

    # Small energetic dot at start of track
    $dotBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 255, 255, 255))
    $dotRadius = 14.0 * $s
    $dotAngleRad = (-70.0 * [Math]::PI) / 180.0
    $dotX = $centerX + ($ringRadius * [Math]::Cos($dotAngleRad))
    $dotY = $centerY + ($ringRadius * [Math]::Sin($dotAngleRad))
    $g.FillEllipse($dotBrush, ($dotX - $dotRadius), ($dotY - $dotRadius), ($dotRadius * 2), ($dotRadius * 2))
    $dotBrush.Dispose()

    # 2. Medical Cross Base (Pure White, Rounded)
    $crossW = 130.0 * $s
    $crossL = 420.0 * $s
    $cr = 46.0 * $s # corner radius

    $crossPath = New-Object System.Drawing.Drawing2D.GraphicsPath
    # Vertical bar
    $vPath = Create-RoundedRectanglePath ($centerX - $crossW / 2.0) ($centerY - $crossL / 2.0) $crossW $crossL $cr
    # Horizontal bar
    $hPath = Create-RoundedRectanglePath ($centerX - $crossL / 2.0) ($centerY - $crossW / 2.0) $crossL $crossW $cr

    $crossPath.AddPath($vPath, $false)
    $crossPath.AddPath($hPath, $false)
    $vPath.Dispose()
    $hPath.Dispose()

    # Subtle soft drop shadow behind the cross
    $shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(35, 0, 0, 0))
    $g.TranslateTransform(0, (14.0 * $s))
    $g.FillPath($shadowBrush, $crossPath)
    $g.TranslateTransform(0, (-14.0 * $s))
    $shadowBrush.Dispose()

    # Fill Medical Cross with Crisp White
    $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
    $g.FillPath($whiteBrush, $crossPath)
    $whiteBrush.Dispose()

    # 3. Energetic Fitness ECG Pulse Wave intersecting smoothly through the center
    # Pulse path coordinates relative to center
    $pulsePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255, 34, 115, 78), (28.0 * $s))
    $pulsePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pulsePen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round

    $p1 = New-Object System.Drawing.PointF(($centerX - 180.0 * $s), $centerY)
    $p2 = New-Object System.Drawing.PointF(($centerX - 70.0 * $s), $centerY)
    $p3 = New-Object System.Drawing.PointF(($centerX - 35.0 * $s), ($centerY + 45.0 * $s))
    $p4 = New-Object System.Drawing.PointF(($centerX + 15.0 * $s), ($centerY - 105.0 * $s)) # Dynamic high peak
    $p5 = New-Object System.Drawing.PointF(($centerX + 60.0 * $s), ($centerY + 75.0 * $s))  # Recovery dip
    $p6 = New-Object System.Drawing.PointF(($centerX + 95.0 * $s), $centerY)
    $p7 = New-Object System.Drawing.PointF(($centerX + 180.0 * $s), $centerY)

    $points = [System.Drawing.PointF[]]@($p1, $p2, $p3, $p4, $p5, $p6, $p7)
    $g.DrawLines($pulsePen, $points)
    $pulsePen.Dispose()
    $crossPath.Dispose()

    # 4. Stylized "Y" apex dot (vibrant fitness energy point at apex of heartbeat)
    $peakBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 46, 175, 115))
    $peakR = 9.0 * $s
    $g.FillEllipse($peakBrush, ($centerX + 15.0 * $s - $peakR), ($centerY - 105.0 * $s - $peakR), ($peakR * 2), ($peakR * 2))
    $peakBrush.Dispose()
}

function Generate-MasterLegacy([int]$size, [bool]$isRound) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    $margin = $size * 0.05
    $w = $size - (2.0 * $margin)

    # Gradient background
    $rect = New-Object System.Drawing.RectangleF($margin, $margin, $w, $w)
    $gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rect,
        [System.Drawing.Color]::FromArgb(255, 52, 148, 107), # Light Sage Emerald top
        [System.Drawing.Color]::FromArgb(255, 27, 89, 61),   # Deep Forest Green bottom
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )

    if ($isRound) {
        $g.FillEllipse($gradBrush, $rect)
    } else {
        $radius = $w * 0.22 # Smooth modern squircle radius
        $bgPath = Create-RoundedRectanglePath $margin $margin $w $w $radius
        $g.FillPath($gradBrush, $bgPath)
        $bgPath.Dispose()
    }
    $gradBrush.Dispose()

    # Draw emblem
    Draw-YHealthEmblem $g ($size / 2.0) ($size / 2.0) ($size / 1024.0)

    $g.Dispose()
    return $bmp
}

function Generate-MasterForeground([int]$size) {
    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)

    # For Android adaptive icon foreground (108dp), safe zone is 66dp (61%)
    # So scale emblem by 0.72 inside the 1024 canvas
    $scale = ($size / 1024.0) * 0.76
    Draw-YHealthEmblem $g ($size / 2.0) ($size / 2.0) $scale

    $g.Dispose()
    return $bmp
}

function Resize-Bitmap([System.Drawing.Bitmap]$source, [int]$targetWidth, [int]$targetHeight) {
    $target = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($target)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.DrawImage($source, 0, 0, $targetWidth, $targetHeight)
    $g.Dispose()
    return $target
}

# Generate 1024 masters
"Generating 1024 master icons..."
$masterSquare = Generate-MasterLegacy 1024 $false
$masterRound = Generate-MasterLegacy 1024 $true
$masterFg = Generate-MasterForeground 1024

$resBase = "C:\develop\yhealth\android\app\src\main\res"

# Mipmap configurations: name, launcherSize, foregroundSize
$densities = @(
    @{ Name = "mipmap-mdpi";    Launcher = 48;  Fg = 108 },
    @{ Name = "mipmap-hdpi";    Launcher = 72;  Fg = 162 },
    @{ Name = "mipmap-xhdpi";   Launcher = 96;  Fg = 216 },
    @{ Name = "mipmap-xxhdpi";  Launcher = 144; Fg = 324 },
    @{ Name = "mipmap-xxxhdpi"; Launcher = 192; Fg = 432 }
)

foreach ($d in $densities) {
    $dir = Join-Path $resBase $d.Name
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    # 1. ic_launcher.png
    $launcherBmp = Resize-Bitmap $masterSquare $d.Launcher $d.Launcher
    $launcherPath = Join-Path $dir "ic_launcher.png"
    $launcherBmp.Save($launcherPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $launcherBmp.Dispose()

    # 2. ic_launcher_round.png
    $roundBmp = Resize-Bitmap $masterRound $d.Launcher $d.Launcher
    $roundPath = Join-Path $dir "ic_launcher_round.png"
    $roundBmp.Save($roundPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $roundBmp.Dispose()

    # 3. ic_launcher_foreground.png
    $fgBmp = Resize-Bitmap $masterFg $d.Fg $d.Fg
    $fgPath = Join-Path $dir "ic_launcher_foreground.png"
    $fgBmp.Save($fgPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $fgBmp.Dispose()

    Write-Host "Generated assets for $($d.Name): $($d.Launcher)x$($d.Launcher) and Fg $($d.Fg)x$($d.Fg)"
}

$masterSquare.Dispose()
$masterRound.Dispose()
$masterFg.Dispose()

Write-Host "All Android launcher icon PNG resolutions generated successfully!"
