# 从 mysql 数据库表结构定义生成相应的 C++ 定义头文件

## 用途

```bash
$ ./stable.pl > tabledef.hpp 2>/dev/null
```

将根据 `config.pl` 配置信息连接数据库，将表结构转为对应的 C++ struct 结构定义
。纯数据结构定义，可期望用于其他类设计等用途。
