Add-Type -AssemblyName System.Drawing

$OutputDir = Join-Path $PSScriptRoot "..\screenshots"
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$dataFile = Join-Path $PSScriptRoot "screenshots_data.json"
$items = Get-Content $dataFile -Raw | ConvertFrom-Json

foreach ($item in $items) {
    $Width = 980
    $Height = 620
    $Type = $item.type

    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    $bgColor = if ($Type -eq 'browser') { [System.Drawing.Color]::FromArgb(245, 247, 250) } else { [System.Drawing.Color]::FromArgb(30, 30, 30) }
    $titleBgColor = if ($Type -eq 'browser') { [System.Drawing.Color]::FromArgb(230, 233, 238) } else { [System.Drawing.Color]::FromArgb(45, 45, 45) }
    $g.Clear($bgColor)

    # Window header bar
    $titleBrush = New-Object System.Drawing.SolidBrush $titleBgColor
    $g.FillRectangle($titleBrush, 0, 0, $Width, 38)
    $titleBrush.Dispose()

    # Window control dots
    $redBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 95, 86))
    $yellowBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 189, 46))
    $greenBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(39, 201, 63))
    $g.FillEllipse($redBrush, 14, 13, 12, 12)
    $g.FillEllipse($yellowBrush, 34, 13, 12, 12)
    $g.FillEllipse($greenBrush, 54, 13, 12, 12)
    $redBrush.Dispose(); $yellowBrush.Dispose(); $greenBrush.Dispose()

    # Title text
    $titleFont = [System.Drawing.Font]::new("Segoe UI", [float]10)
    $titleTextBrush = if ($Type -eq 'browser') { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(50, 50, 50)) } else { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(204, 204, 204)) }
    $g.DrawString($item.title, $titleFont, $titleTextBrush, [float]80, [float]10)
    $titleFont.Dispose(); $titleTextBrush.Dispose()

    # Content
    if ($Type -eq 'browser') {
        # Browser URL bar
        $urlBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $urlBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200, 205, 212))
        $g.FillRectangle($urlBg, 80, 48, ($Width - 160), 28)
        $g.DrawRectangle($urlBorder, 80, 48, ($Width - 160), 28)
        $urlFont = [System.Drawing.Font]::new("Segoe UI", [float]9.5)
        $urlBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(100, 100, 100))
        $g.DrawString("http://127.0.0.1:5000/", $urlFont, $urlBrush, [float]95, [float]52)
        $urlBg.Dispose(); $urlBorder.Dispose(); $urlFont.Dispose(); $urlBrush.Dispose()

        # Web page Card
        $cardBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $cardBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(220, 224, 230))
        $g.FillRectangle($cardBg, 50, 95, ($Width - 100), ($Height - 120))
        $g.DrawRectangle($cardBorder, 50, 95, ($Width - 100), ($Height - 120))

        # Card Title
        $h1Font = [System.Drawing.Font]::new("Segoe UI", [float]18, [System.Drawing.FontStyle]::Bold)
        $h1Brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(33, 37, 41))
        $g.DrawString("NLP - Emotion Detection", $h1Font, $h1Brush, [float]80, [float]120)

        # Label 1
        $lblFont = [System.Drawing.Font]::new("Segoe UI", [float]12)
        $lblBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(73, 80, 87))
        $g.DrawString("Please enter the text to be analyzed", $lblFont, $lblBrush, [float]80, [float]170)

        # Input box
        $inBorder = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(206, 212, 218))
        $g.FillRectangle($cardBg, 80, 200, ($Width - 160), 40)
        $g.DrawRectangle($inBorder, 80, 200, ($Width - 160), 40)
        $inFont = [System.Drawing.Font]::new("Segoe UI", [float]11)
        $inTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(33, 37, 41))
        $g.DrawString($item.browserInput, $inFont, $inTextBrush, [float]90, [float]209)

        # Button
        $btnBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(108, 117, 125))
        $g.FillRectangle($btnBg, 80, 260, 220, 42)
        $btnFont = [System.Drawing.Font]::new("Segoe UI", [float]10.5, [System.Drawing.FontStyle]::Bold)
        $btnTextBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)
        $g.DrawString("Run Sentiment Analysis", $btnFont, $btnTextBrush, [float]105, [float]271)

        # Result Label
        $g.DrawString("Result of Emotion Detection", $lblFont, $lblBrush, [float]80, [float]330)

        # Result display
        $isErr = [bool]$item.isError
        $resBg = if ($isErr) { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 235, 235)) } else { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(240, 244, 248)) }
        $resBorder = if ($isErr) { New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(235, 120, 120)) } else { New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(200, 215, 230)) }
        $g.FillRectangle($resBg, 80, 365, ($Width - 160), 100)
        $g.DrawRectangle($resBorder, 80, 365, ($Width - 160), 100)

        $resStyle = if ($isErr) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
        $resFont = [System.Drawing.Font]::new("Segoe UI", [float]11.5, $resStyle)
        $resTextBrush = if ($isErr) { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(180, 40, 40)) } else { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(20, 50, 90)) }
        $layoutRect = New-Object System.Drawing.RectangleF 95, 380, ($Width - 190), 80
        $g.DrawString($item.browserResult, $resFont, $resTextBrush, $layoutRect)

        $cardBg.Dispose(); $cardBorder.Dispose(); $h1Font.Dispose(); $h1Brush.Dispose()
        $lblFont.Dispose(); $lblBrush.Dispose(); $inBorder.Dispose(); $inFont.Dispose(); $inTextBrush.Dispose()
        $btnBg.Dispose(); $btnFont.Dispose(); $btnTextBrush.Dispose(); $resBg.Dispose(); $resBorder.Dispose()
        $resFont.Dispose(); $resTextBrush.Dispose()
    }
    else {
        # Editor or Terminal text
        $codeFont = [System.Drawing.Font]::new("Consolas", [float]10.5)
        $numFont = [System.Drawing.Font]::new("Consolas", [float]10)
        $lineNumBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(110, 118, 129))
        $defaultBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(212, 212, 212))
        $keywordBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(197, 134, 192))
        $commentBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(106, 153, 85))
        $promptBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(78, 201, 176))
        $passBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(106, 215, 106))
        $highlightBg = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(40, 60, 85))

        $y = 52
        $lineNum = 1

        foreach ($line in $item.lines) {
            $isHL = $line.StartsWith("[HL]")
            $cleanLine = if ($isHL) { $line.Substring(4) } else { $line }

            if ($isHL) {
                $g.FillRectangle($highlightBg, 0, ($y - 2), $Width, 22)
            }

            if ($Type -eq 'editor') {
                $g.DrawString(("{0,3}" -f $lineNum), $numFont, $lineNumBrush, [float]12, [float]$y)
                $x = 55
            } else {
                $x = 20
            }

            $curBrush = $defaultBrush
            if ($cleanLine.StartsWith("theia@") -or $cleanLine.StartsWith(">>>")) {
                $curBrush = $promptBrush
            } elseif ($cleanLine.Trim().StartsWith("#") -or $cleanLine.Contains('"""') -or $cleanLine.Contains("'''")) {
                $curBrush = $commentBrush
            } elseif ($cleanLine.Contains("OK") -or $cleanLine.Contains("Successfully") -or $cleanLine.Contains("10.00/10")) {
                $curBrush = $passBrush
            } elseif ($cleanLine -match '^\s*(def |import |from |return |if |else|elif |class )') {
                $curBrush = $keywordBrush
            }

            $g.DrawString($cleanLine, $codeFont, $curBrush, [float]$x, [float]$y)

            $y += 22
            $lineNum++
        }

        $codeFont.Dispose(); $numFont.Dispose(); $lineNumBrush.Dispose(); $defaultBrush.Dispose()
        $keywordBrush.Dispose(); $commentBrush.Dispose()
        $promptBrush.Dispose(); $passBrush.Dispose(); $highlightBg.Dispose()
    }

    $outPath = Join-Path $OutputDir $item.fileName
    $bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Generated: $($item.fileName)"
}

Write-Host "Completed all 16 screenshot generations!"
