
#!/bin/bash

# 脚本名称: writer.sh
# 用途: 创建一个文件并写入指定文本，支持创建不存在的目录。

# 1. 参数检查：检查是否提供了两个参数
#    $# 是传递给脚本的参数总数。
#    -ne 表示 "not equal" (不等于)。
if [ $# -ne 2 ]; then
    # 如果参数数量不为2，则打印错误信息到标准错误输出 (>&2)
    echo "错误：需要两个参数：writefile 和 writestr。" >&2
    echo "用法: $0 <writefile> <writestr>" >&2
    # 退出脚本，并返回错误码 1
    exit 1
fi

# 2. 将参数赋值给可读性更高的变量名
#    $1 是第一个参数 (writefile)
#    $2 是第二个参数 (writestr)
writefile="$1"
writestr="$2"

# 3. 创建目录路径（如果不存在）
#    dirname "$writefile": 提取文件路径中的目录部分。
#        例如：dirname "/tmp/aesd/sample.txt" 会返回 "/tmp/aesd"
#    mkdir -p "$dir_path":
#        mkdir: 创建目录。
#        -p (parents): 如果父目录不存在，则创建父目录。
#        "$dir_path": 要创建的目录路径。
#    $? : 检查上一个命令的退出状态。0 表示成功，非0表示失败。
dir_path=$(dirname "$writefile")
mkdir -p "$dir_path"

# 检查 mkdir 是否成功
if [ $? -ne 0 ]; then
    echo "错误：无法创建目录 '$dir_path'。" >&2
    exit 1
fi

# 4. 将文本写入文件
#    echo "$writestr": 打印变量 writestr 的内容。
#    > "$writefile": 将 echo 的标准输出重定向到文件 "$writefile"。
#        这会覆盖文件的现有内容，如果文件不存在则创建。
#    $? : 检查上一个命令的退出状态。
echo "$writestr" > "$writefile"

# 检查文件写入是否成功
if [ $? -ne 0 ]; then
    echo "错误：无法写入文件 '$writefile'。" >&2
    exit 1
fi

# 5. 成功退出
#    脚本成功执行完毕，返回退出码 0 (表示成功)。
exit 0