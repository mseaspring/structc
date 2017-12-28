﻿#include <chead.h>
#include <stdext.h>

//
// main - 程序的总入口, 从扯开始
// argc     : 输入参数个数
// argv     : 参数集
// return   : 返回程序退出的状态码
//
int main(int argc, char * argv[]) {
    //
    // 各种环境初始化内容
    // ... ...

    //
    // make D=-D_DEBUG
    // main_test 单元测试才会启动
    //
#if defined(_DEBUG)
    EXTERN_RUN(main_test);
#endif

    // ... 
    // ... 启动当前项目运行的主函数
    //
    EXTERN_RUN(main_run);

	return EXIT_SUCCESS;
}