#! /usr/bin/env perl
package config;
use strict;
use warnings;

# 将配置项按 key => value, 的格式放在下面的 {} 之间
our $entry = {
	# 数据库连接信息
	host => '192.168.?.?',
	user => '?',
	pass => '?',
	database => '?',

	# 数据库字符集使用 utf8 编码
	utf8 => 1,

	# 表结构定义的生成模板文件
	struct_template => 'table_def_tmp.h',

	# 分表匹配模式及改名替换原则
	fractor_pattern => '_\d\d$',
	fractor_replace => '_',

	# 忽略的表名
	table_ignore => '^test_',
	# 忽略名字太短的表
	table_minlen => 4,
};

print "config valide\n" unless caller;
1;
__END__
可通过执行该脚本检查配置有效性，其实也就是个 perl 脚本：
$ perl config.pl
