
#!/bin/bash

# 脚本名称: finder.sh
# 用途: 在指定目录及其子目录中查找文件，并统计包含特定字符串的行数。

# 1. 参数检查：检查是否提供了两个参数
#    $# 是传递给脚本的参数总数。
#    -ne 表示 "not equal" (不等于)。
if [ $# -ne 2 ]; then
    # 如果参数数量不为2，则打印错误信息到标准错误输出 (>&2)
    echo "错误：需要两个参数：filesdir 和 searchstr。" >&2
    echo "用法: $0 <filesdir> <searchstr>" >&2
    # 退出脚本，并返回错误码 1
    exit 1
fi

# 2. 将参数赋值给可读性更高的变量名
#    $1 是第一个参数 (filesdir)
#    $2 是第二个参数 (searchstr)
filesdir="$1"
searchstr="$2"

# 3. 检查 filesdir 是否是一个目录
#    [ ! -d "$filesdir" ]
#    ! 表示 "not" (逻辑非)
#    -d "$filesdir" 检查 "$filesdir" 是否存在并且是一个目录。
#    使用双引号 "$filesdir" 是一个好习惯，可以处理路径中包含空格或特殊字符的情况。
if [ ! -d "$filesdir" ]; then
    # 如果 "$filesdir" 不是一个目录，则打印错误信息到标准错误输出
    echo "错误：'$filesdir' 不是一个有效的目录。" >&2
    # 退出脚本，并返回错误码 1
    exit 1
fi

# 4. 计算文件数 (X) 和匹配行数 (Y)

# 计算文件数 X:
#   find "$filesdir"   : 从 "$filesdir" 目录开始查找。
#   -type f            : 只查找普通文件 (不包括目录、符号链接等)。
#   | (管道)           : 将前一个命令的输出作为后一个命令的输入。
#   wc -l              : word count (字数统计) 命令，-l 选项表示统计行数。
#                        由于 find 每找到一个文件就输出一行文件名，所以行数即文件数。
#   $(...)             : 命令替换，执行括号内的命令，并将其标准输出替换到当前位置。
num_files=$(find "$filesdir" -type f | wc -l)

# 计算匹配行数 Y:
#   grep -r "$searchstr" "$filesdir" :
#     grep               : 文本搜索工具。
#     -r (或 --recursive): 递归搜索。它会搜索 "$filesdir" 目录及其所有子目录中的文件。
#                          注意：grep -r 会自动处理文件，我们不需要先用 find 找到文件再传给 grep。
#     "$searchstr"       : 要搜索的文本字符串。使用双引号以处理包含空格的字符串。
#     "$filesdir"        : 开始搜索的目录路径。
#     此命令会输出所有包含 "$searchstr" 的行。
#   | wc -l              : 统计 grep 命令输出的行数，即匹配到的总行数。
num_matching_lines=$(grep -r "$searchstr" "$filesdir" | wc -l)
#   注意: 如果 grep 没有找到任何匹配项，它不会输出任何内容，wc -l 会正确地返回 0。
#   如果 "$filesdir" 为空或不包含任何文件，find ... | wc -l 会返回 0，
#   grep -r ... | wc -l 也会返回 0，这都是符合预期的。

# 5. 打印结果
#    使用双引号以便变量 ($num_files, $num_matching_lines) 被正确替换。
echo "文件数为 $num_files，匹配行数为 $num_matching_lines"

# 6. 成功退出
#    脚本成功执行完毕，返回退出码 0 (表示成功)。
exit 0