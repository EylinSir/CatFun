#!/bin/bash
FILE="lib/git_info.dart"

# 获取Git提交信息
COMMIT=$(git rev-parse --short HEAD)
DESCRIBE=$(git describe --tags --always)

# 解析版本信息
BUILD=$(echo "$DESCRIBE" | awk '{split($0,a,"-"); print a[2]}')
PATCH=$(echo "$DESCRIBE" | awk '{split($0,a,"-"); print a[3]}')

# 如果只有哈希值，使用提交计数作为构建号
if [[ "${DESCRIBE}" =~ ^[A-Fa-f0-9]+$ ]]; then
    BUILD=$(git rev-list HEAD --count)
    PATCH=${DESCRIBE}
fi

# 确保BUILD有值
if [ -z "${BUILD}" ]; then
    BUILD='0'
fi

# 确保PATCH有值
if [ -z "${PATCH}" ]; then
    PATCH=$DESCRIBE
fi

# 构建版本号
REAL_VERSION="${BUILD}.${PATCH}"

# 写入版本信息文件
echo "const gitCommit = '$COMMIT';" > "$FILE"
echo "const gitTag = '$REAL_VERSION';" >> "$FILE"

echo "Generated git_info.dart with version: $REAL_VERSION"