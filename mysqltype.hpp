#ifndef MYDATATYPE_HPP__
#define MYDATATYPE_HPP__

#include <string>

namespace mysql
{
	// 整数
	typedef char TINYINT; // 1
	typedef short SMALLINT; // 2
	typedef int MEDIUMINT; // 3
	typedef int INT;  // 4
	typedef int INTEGER; // 4
	typedef long BIGINT; // 8

	// 小数
	typedef double DECIMAL;
	typedef double NUMERIC;
	typedef double DOUBLE;
	typedef float FLOAT;

	// 位域？
	// typedef unsigned long BIT;

	// 时间日期
	typedef std::string DATE;
	typedef std::string DATETIME;
	typedef std::string TIME;
	typedef std::string YEAR;
	typedef unsigned int TIMESTAMP;

	// 字符
	typedef std::string CHAR;
	typedef std::string VARCHAR;
	typedef std::string BINARY;
	typedef std::string VARBINARY;
	typedef std::string BLOB;
	typedef std::string TEXT;
	typedef std::string ENUM;
	typedef std::string SET;

	// mysql5.7.8 直接支持 JSON
	// typedef Json::Value JSON;
}


#endif /* end of include guard: MYDATATYPE_HPP__ */
