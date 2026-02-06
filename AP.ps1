# 获取所有网络连接配置文件
$allProfiles = [Windows.Networking.Connectivity.NetworkInformation,Windows.Networking.Connectivity,ContentType=WindowsRuntime]::GetConnectionProfiles() | 
    Where-Object { $_.ProfileName -ne $null -and $_.ProfileName -ne '' }

# 简单过滤：排除虚拟适配器和蓝牙，且只保留已连接的网络
$profiles = $allProfiles | Where-Object { 
#     $_.ProfileName -notmatch '^vEthernet|^Bluetooth|蓝牙网络|^VMware|^VirtualBox|^Hyper-V|^Local Area Connection\*'
# } | Where-Object {
    $_.GetNetworkConnectivityLevel() -ne 'None'
}

# 检查是否有可用的配置文件
if ($profiles.Count -eq 0) {
    Write-Host "未找到任何网络连接配置文件！" -ForegroundColor Red
    exit
}

# 显示所有可用的网络连接
Write-Host "`n========== 可用的网络连接 ==========" -ForegroundColor Cyan
for ($i = 0; $i -lt $profiles.Count; $i++) {
    $status = $profiles[$i].GetNetworkConnectivityLevel()
    $statusText = switch ($status) {
        "None" { "[未连接]" }
        "LocalAccess" { "[本地访问]" }
        "ConstrainedInternetAccess" { "[受限]" }
        "InternetAccess" { "[已连接]" }
        default { "[$status]" }
    }
    Write-Host "  [$($i + 1)] $($profiles[$i].ProfileName) $statusText"
}
Write-Host "======================================`n" -ForegroundColor Cyan

# 提示用户选择
$selection = Read-Host "请输入序号选择要共享的网络连接 (1-$($profiles.Count))"

# 验证输入
if ($selection -notmatch '^\d+$' -or [int]$selection -lt 1 -or [int]$selection -gt $profiles.Count) {
    Write-Host "无效的选择！" -ForegroundColor Red
    exit
}

# 获取选中的配置文件（序号-1转为索引）
$selectedProfile = $profiles[[int]$selection - 1]
Write-Host "`n正在启动热点，共享网络: $($selectedProfile.ProfileName)..." -ForegroundColor Yellow

# 创建热点管理器并启动热点
$tether = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringManager,Windows.Networking.NetworkOperators,ContentType=WindowsRuntime]::CreateFromConnectionProfile($selectedProfile)

# 使用 AsTask() 转换 WinRT 异步操作
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]

$asyncOp = $tether.StartTetheringAsync()
$netOpResult = [Windows.Networking.NetworkOperators.NetworkOperatorTetheringOperationResult,Windows.Networking.NetworkOperators,ContentType=WindowsRuntime]
$asTask = $asTaskGeneric.MakeGenericMethod($netOpResult)
$task = $asTask.Invoke($null, @($asyncOp))
$result = $task.GetAwaiter().GetResult()

# 显示结果
if ($result.Status -eq 'Success') {
    Write-Host "热点启动成功！" -ForegroundColor Green
} else {
    Write-Host "热点启动失败: $($result.Status)" -ForegroundColor Red
} 