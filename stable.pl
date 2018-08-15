#! /usr/bin/env perl
# 将数据库里的表生成相应的 c++ struct 定义头文件
# 请参考配置 config.pl 及相应的模板文件
# 打印至标准输出，需要时自行重定向
# 使用方法：./stable.pl [> tabledef.hpp] [2>/dev/null]
package stable;
use strict;
use warnings;

use DBI;
require "./config.pl";

# 获取数据库连接
my $dbname = $config::entry->{database};
my $dbh = db_connect();

# 查表名语句
my $sql_tables = <<SQL;
select TABLE_NAME from information_schema.tables where table_schema = '$dbname'
SQL

# 查各表定义（列名）语句模板
my $stp_tabdef = <<SQL;
select COLUMN_NAME, DATA_TYPE, COLUMN_TYPE, COLUMN_KEY, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
from information_schema.columns
where table_schema = ? and table_name = ?
SQL
my $sth_tabdef = $dbh->prepare($stp_tabdef) or die $dbh->errstr;

# 获取数据库中所有表名
my $fractor_pattern = $config::entry->{fractor_pattern} // '';
my $fractor_replace = $config::entry->{fractor_replace} // '';
my $table_names = $dbh->selectcol_arrayref($sql_tables);
$table_names = filter_tables($table_names);
# debug_tables($table_names);

deal_tables($table_names);
$dbh->disconnect();

######################################################################
## MAIN END ##
######################################################################

sub db_connect
{
	my $dbhost = $config::entry->{host};
	my $username = $config::entry->{user};
	my $password = $config::entry->{pass};
	my $driver = "mysql";
	my $dsn = "database=$dbname";
	$dsn .= ";host=$dbhost" if $dbhost;
	my $flag = {};
	my $utf8 = $config::entry->{utf8};
	$flag->{mysql_enable_utf8} = 1 if $utf8;

	my $dbh = DBI->connect("dbi:$driver:$dsn", $username, $password, $flag)
		or die "Failed to connect to dbi: $DBI::errstr";
	# warn "Hello, Mysql DBI\n";
	return $dbh;
}

# 处理每个表
sub deal_tables
{
	my ($tabref) = @_;
	my $tempfile = $config::entry->{struct_template};
	my $temp = read_temp_header($tempfile);

	# 输出模板文件头部
	print $temp->[0];

	# 输出每个表的定义
	foreach my $name (@$tabref) {
		my $base = $name;
		if ($fractor_pattern && $name =~ $fractor_pattern) {
			 $base =~ s/$fractor_pattern/$fractor_replace/;
		}
		table_define($base, $name);
		print "\n";
	}

	# 输出模板文件尾部
	print $temp->[1];
}

# 打印一个表的定义
sub table_define
{
	my ($struct_name, $table_name) = @_;
	my $indent = ' ' x 4;

	$sth_tabdef->execute($dbname, $table_name) or die $dbh->errstr;
	print "struct $struct_name\n{\n";
	while (my $col = $sth_tabdef->fetchrow_hashref()) {
		my $name = $col->{COLUMN_NAME};
		# my $type = $col->{COLUMN_TYPE};
		my $type = $col->{DATA_TYPE};
		my $bkey = $col->{COLUMN_KEY};
		my $null = $col->{IS_NULLABLE};
		my $deft = $col->{COLUMN_DEFAULT} // 'NULL';
		my $comt = $col->{COLUMN_COMMENT};
		# print "$name = $type, $bkey, $null, $deft // $comt\n";

		# print "$indent$ctype $name;";
		printf "$indent%-10s $name;", uc($type);
		print "\tPRIKEY" if $bkey;
		print "\tDEFAULT($deft)" if $deft ne 'NULL';
		# $comt 注释有中文的话，若有处理编码会有警告
		print "\t//$comt" if $comt;
		print "\n";
	}
	print "};\n";
}

# 过滤冗余分表，也忽略表名太短的测试表
sub filter_tables
{
	my ($tabref) = @_;
	my @tables = ();
	my %fractor_base = ();
	my $minlen = $config::entry->{table_minlen};
	my $ignore = $config::entry->{table_ignore};

	foreach my $name (@$tabref) {
		next if length($name) < $minlen;
		next if $name =~ $ignore;
		next if $name =~ /\./;
		if ($fractor_pattern && $name =~ $fractor_pattern) {
			(my $base = $name) =~ s/$fractor_pattern/$fractor_replace/;
			if (not defined $fractor_base{$base}) {
				push(@tables, $name);
				$fractor_base{$base} = 1;
			}
			next;
		}
		push(@tables, $name);
		$fractor_base{$name} = 1;
	}
	
	return \@tables;
}

# 查看获得多少表名
sub debug_tables
{
	my ($tabref) = @_;
	my $n = 0;
	foreach my $name (@$tabref) {
		$n++;
		print "$n\t$name\n";
	}
}

# 读取一个模板文件，返回头部与尾部的文件行（包含回车的字符串）
# 中间部分与程序生成，识别 #ifdef CODE_GENERTOR_BODY 与 #endif
# 返回值是一个列表引用，包含两个标量字符串
sub read_temp_header
{
	my ($filename) = @_;
	my @head = ();
	my @foot = ();

	my $begpat = '^\s*#ifdef CODE_GENERTOR_BODY';
	my $endpat = '^\s*#endif';
	my $begflag = 0;
	my $endflag = 0;

	open(my $fh, '<', $filename) or die "cannot open $filename $!";
	while (<$fh>) {
		if (/$begpat/){
			$begflag = 1;
			next;
		}
		if ($begflag && /$endpat/){
			$begflag = 0;
			$endflag = 1;
			next;
		}
		if (!$begflag && !$endflag) {
			push(@head, $_);
		}
		elsif ($endflag) {
			push(@foot, $_);
		}
	}
	close($fh);

	return [join("", @head), join("", @foot)];
}

1;
__END__
