# PowerShell script to generate git_info.dart
$FILE = "lib/git_info.dart"

# 获取Git提交信息
$COMMIT = git rev-parse --short HEAD
$DESCRIBE = git describe --tags --always

# 解析版本信息
$VERSION = ($DESCRIBE -split '-')[0]
$BUILD = ($DESCRIBE -split '-')[1]
$PATCH = ($DESCRIBE -split '-')[2]

# 如果只有哈希值，使用提交计数作为构建号
if ($DESCRIBE -match '^[A-Fa-f0-9]+$') {
    $BUILD = $(git rev-list HEAD --count)
    $PATCH = $DESCRIBE
}

# 确保BUILD有值
if (-not $BUILD) {
    $BUILD = '0'
}

# 确保PATCH有值
if (-not $PATCH) {
    $PATCH = $DESCRIBE
}

# 构建版本号
$REAL_VERSION = "$BUILD.$PATCH"

# 写入版本信息文件
Set-Content -Path $FILE -Value "const gitCommit = '$COMMIT';`nconst gitTag = '$REAL_VERSION';"

Write-Host "Generated git_info.dart with version: $REAL_VERSION"
