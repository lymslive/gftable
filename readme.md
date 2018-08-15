# 从 mysql 数据库表结构定义生成相应的 C++ 定义头文件

## 用途

```bash
$ ./stable.pl > tabledef.hpp 2>/dev/null
```

将根据 `config.pl` 配置信息连接数据库，将表结构转为对应的 C++ struct 结构定义
。纯数据结构定义，可期望用于其他类设计等用途。

可以将配置及模板文件放在项目工程下面合适的位置，与可执行脚本分开放置。例如：
```bash
$ cp config.pl  mysqltype.hpp  table_def_tmp.h $project/subdir
$ cp stable.pl ~/bin/
$ cd $project/subdir
$ stable.pl > tabledef.hpp 2>/dev/null
```

## 文件说明

* `config.pl` 配置文件。也是合法 perl 脚本，不必熟悉 perl ，按上下行范例定义键
  值对即可。执行 `perl config.pl` 可检测脚本语法正确性。
* `table_def_tmp.h` 模板文件，具体可名字在 `config.pl` 中配置，如果不是绝对路
  径，则表示相对当前 shell 工作目录的相对路径。
* `mysqltype.hpp` 被 `table_def_tmp.h` include 包含的静态头文件，比如用
  typedef 定义从 mysql 数据类型到 C++ 类型的映射。
* `stable.pl` 可执行程序，生成的代码将替换模板文件的中间部分，向标准输出，若要
  保存文件，用重定向。如果 mysql 有中文注释，可能会生成警告（但不影响生成的结
  果），如不想看到警告，可将标准错误定向到 /dev/null 。

注意：执行脚本时，当前路径请切换到 `config.pl` 配置相同的路径。`stable.pl` 可
执行脚本若不在 `$PATH` 中，请用全路径。

## 后续计划

生成纯粹的数据结构定义，只是最基础的一步工作。但是至少可以放在项目中用 IDE 或
ctags 之类的工具生成符号索引，方便在编程中跳转到表定义处。

如果要支持结构体数据直接存取数据库，将会更复杂，可以有实现方案，但也要视具体项
目是否需要。
