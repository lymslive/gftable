#include <iostream>
#include "tabledef.hpp"

int main(int argc, char *argv[])
{
	std::cout << "Hello, mysql table!" << std::endl;

	// 使用生成的 struct
	mysql::t_order_ stOrder;
	stOrder.F_order_id = "123456789";
	stOrder.F_amount = 4321;
	stOrder.F_create_time = "2018-08-08";
	std::cout << "order: id=" << stOrder.F_order_id 
		<< "; amount=" << stOrder.F_amount
		<< "; time=" << stOrder.F_create_time
		<< std::endl;

	return 0;
}
