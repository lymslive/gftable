#ifndef MYSQL_TABLE_DEF_TMP_H__
#define MYSQL_TABLE_DEF_TMP_H__

/**
 * 代码自动生成，不建议手动修改
 */

// 类型映射
#include "mysqltype.hpp"

// mysql 特性标记
#define PRIKEY
#define DEFAULT(x)

namespace mysql
{

#ifdef CODE_GENERTOR_BODY
// 代码生成部分
// 程序完全忽略此部分，用生成的文本代码替换；但原样输出前后两部分
// 生成代码示例如下：
struct table_name_
{
	BIGINT     id;	PRIKEY
	VARCHAR    name;	DEFAULT()
	DATETIME   create_time;	// 创建时间
};

#endif
}

// 取消标记宏，避免影响外部
#undef PRIKEY
#undef DEFAULT

#endif /* end of include guard: TABLE_DEF_TMP_H__ */
