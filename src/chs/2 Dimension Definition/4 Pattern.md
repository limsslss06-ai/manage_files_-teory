# 结构模板（pattern）

`<pattern>` 定义代码在架构中的角色与组织模式，是四维坐标中描述代码职责与形态的维度。

## 取值


| 结构      | 解释              ||
|-----------|------------------|------|
| adapter   | 适配/转换层，对接不同接口     ||
| api       | 对外暴露的 API 入口       ||
| backend   | 具体技术实现              ||
| benchmark | 性能测试代码              ||
| dto       | 数据传输对象              ||
| enum      | 枚举定义                  ||
| error     | 错误码/异常定义           ||
| event     | 事件定义                  ||
| factory   | 对象创建                  ||
| interface | 抽象接口定义              ||
| mapper    | 数据映射（O/RM、DTO ↔ Entity）||
| model     | 数据模型/实体定义         ||
| pipeline  | 流水线处理（责任链、过滤器） ||
| policy    | 编译期策略                ||
| traits    | 类型特征（编译期）        ||