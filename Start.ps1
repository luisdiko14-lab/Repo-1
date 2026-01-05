Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === Paths ===
$downloads = [Environment]::GetFolderPath("Downloads")
$targetFile = Join-Path $downloads "SU.v26.1.ps1"

# === Form ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "System Utility Checker v26.1"
$form.Size = New-Object System.Drawing.Size(460,260)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::Black
$form.ForeColor = [System.Drawing.Color]::Lime

# === Label ===
$label = New-Object System.Windows.Forms.Label
$label.Text = "Checking system integrity..."
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20,20)
$label.Font = New-Object System.Drawing.Font("Consolas",12)
$form.Controls.Add($label)

# === Progress Bar ===
$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(20,70)
$progress.Size = New-Object System.Drawing.Size(400,25)
$progress.Style = "Continuous"
$form.Controls.Add($progress)

# === Status Box ===
$status = New-Object System.Windows.Forms.TextBox
$status.Location = New-Object System.Drawing.Point(20,120)
$status.Size = New-Object System.Drawing.Size(400,60)
$status.Multiline = $true
$status.ReadOnly = $true
$status.BackColor = [System.Drawing.Color]::Black
$status.ForeColor = [System.Drawing.Color]::Lime
$status.Font = New-Object System.Drawing.Font("Consolas",10)
$form.Controls.Add($status)

# === Timer ===
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 120
$step = 0

$timer.Add_Tick({
    if ($step -lt 100) {
        $step += 5
        $progress.Value = $step
    } else {
        $timer.Stop()

        if (Test-Path $targetFile) {
            # === FOUND ===
            $status.ForeColor = [System.Drawing.Color]::Lime
            $status.Text = "[OK] SU.v26.1.ps1 found in Downloads.`r`nLaunching..."
            Start-Sleep 1
            powershell -ExecutionPolicy Bypass -NoProfile -File $targetFile
            $form.Close()
        } else {
            # === NOT FOUND → FAKE C: INIT ===
            $status.ForeColor = [System.Drawing.Color]::Red
            $status.Text = "ERROR: SU.v26.1.ps1 NOT FOUND.`r`nInitializing C:\ Drive..."

            $progress.Value = 0
            for ($i=0; $i -le 100; $i+=4) {
                $progress.Value = $i
                $status.Text = "WARNING!`r`nInitializing C:\ Drive... $i%"
                Start-Sleep -Milliseconds 120
            }

            [System.Windows.Forms.MessageBox]::Show(
                "CRITICAL ERROR SIMULATION COMPLETE`n(System not harmed)",
                "SYSTEM WARNING",
                "OK",
                "Error"
            )

            $form.Close()
        }
    }
})

$timer.Start()
$form.ShowDialog()
